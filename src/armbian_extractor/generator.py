import json
import logging
import re
import shutil
from pathlib import Path
from .nvgen import sanitize_name

log = logging.getLogger("nixbian-generator")

# Family -> .config fragment mapping for the defconfig tier
# Enables only the drivers needed by each family
# (avoids building amdgpu, xe, ceph, etc. on an SBC)
# Multi-line values in .config syntax: "CONFIG_X=y\nCONFIG_Y=y".
# Consumed by buildKernel through the familyConfig argument (configMode = "defconfig").
FAMILY_CONFIG_FRAGMENTS = {
    "sunxi": "CONFIG_ARCH_SUNXI=y\nCONFIG_MMC_SUNXI=y\nCONFIG_NET_VENDOR_ALLWINNER=y",
    "sunxi64": "CONFIG_ARCH_SUNXI=y\nCONFIG_MMC_SUNXI=y\nCONFIG_PHY_SUN50I_USB3=y\nCONFIG_USB_DWC3=y\nCONFIG_SUN8I_DE2_CCU=y",
    "rockchip": "CONFIG_ARCH_ROCKCHIP=y\nCONFIG_MMC_DWROCKCHIP=y\nCONFIG_PHY_ROCKCHIP_TYPE0=y\nCONFIG_DWMAC_ROCKCHIP=y",
    "rockchip64": "CONFIG_ARCH_ROCKCHIP=y\nCONFIG_MMC_DWROCKCHIP=y\nCONFIG_PHY_ROCKCHIP_INNO_USB2=y\nCONFIG_DWMAC_ROCKCHIP=y\nCONFIG_DRM_ROCKCHIP=y",
    "meson": "CONFIG_ARCH_MESON=y\nCONFIG_MMC_MESON_GX=y",
    "meson64": "CONFIG_ARCH_MESON=y\nCONFIG_MMC_MESON_GX=y\nCONFIG_DWMAC_MESON8B=y\nCONFIG_USB_MESON_G12A=y",
    "bcm2711": "CONFIG_ARCH_BCM2835=y\nCONFIG_BCM2835_MMC=y\nCONFIG_BCM2835_WDT=y",
    "imx6": "CONFIG_ARCH_MXC=y\nCONFIG_MMC_SDHCI_ESDHC_IMX=y",
    "imx8m": "CONFIG_ARCH_MXC=y\nCONFIG_MMC_SDHCI_ESDHC_IMX=y\nCONFIG_DWMAC_IMX8=y",
    "imx93": "CONFIG_ARCH_MXC=y\nCONFIG_MMC_SDHCI_ESDHC_IMX=y",
    "k3": "CONFIG_ARCH_K3=y\nCONFIG_MMC_SDHCI_AM654=y",
    "k3-beagle": "CONFIG_ARCH_K3=y\nCONFIG_MMC_SDHCI_AM654=y",
    "mvebu": "CONFIG_ARCH_MVEBU=y\nCONFIG_MVMDIO=y",
    "mvebu64": "CONFIG_ARCH_MVEBU=y\nCONFIG_MVMDIO=y\nCONFIG_MVPP2=y",
    "starfive2": "CONFIG_ARCH_STARFIVE=y\nCONFIG_STARFIVE_DWP=y",
    "riscv64": "CONFIG_ARCH_STARFIVE=y\nCONFIG_STARFIVE_DWP=y",
    "mt7623": "CONFIG_ARCH_MEDIATEK=y\nCONFIG_MMC_MTK=y",
    "filogic": "CONFIG_ARCH_MEDIATEK=y\nCONFIG_MMC_MTK=y\nCONFIG_USB_MTU3=y",
    "ls1046a": "CONFIG_ARCH_LAYERSCAPE=y\nCONFIG_MMC_SDHCI_OF_ESDHC=y",
    "odroidxu4": "CONFIG_ARCH_EXYNOS=y\nCONFIG_MMC_DW_EXYNOS=y",
    "qcs6490": "CONFIG_ARCH_QCOM=y\nCONFIG_MMC_SDHCI_MSM=y",
    "sm8250": "CONFIG_ARCH_QCOM=y\nCONFIG_MMC_SDHCI_MSM=y",
    "sm8550": "CONFIG_ARCH_QCOM=y\nCONFIG_MMC_SDHCI_MSM=y",
    "qrb2210": "CONFIG_ARCH_QCOM=y\nCONFIG_MMC_SDHCI_MSM=y",
    "generic": "",
    "arm64": "",
    "x86": "",
    "genio": "CONFIG_ARCH_MEDIATEK=y\nCONFIG_MMC_MTK=y",
    "nuvoton-ma35d1": "CONFIG_ARCH_NUVOTON=y\nCONFIG_MMC_NPCM_SDHCI=y",
    "loong64": "",
    "rk35xx": "CONFIG_ARCH_ROCKCHIP=y\nCONFIG_MMC_DWROCKCHIP=y\nCONFIG_PHY_ROCKCHIP_INNO_USB2=y",
    "meson-s4t7": "CONFIG_ARCH_MESON=y\nCONFIG_MMC_MESON_GX=y",
    "phytium-embedded": "CONFIG_ARCH_PHYTIUM=y",
    "spacemit": "CONFIG_ARCH_SPACEMIT=y\nCONFIG_MMC_SDHCI_SPACEMIT=y",
    "realtek-rtd1619b": "CONFIG_ARCH_REALTEK=y\nCONFIG_MMC_REALTEK=y",
    "sun55iw3-syterkit": "CONFIG_ARCH_SUNXI=y\nCONFIG_MMC_SUNXI=y",
    # rockchip-rv1106: no Armbian config extracted
    # (metadata/nix/families/rockchip-rv1106/configs does not exist) -> empty fragment
    "rockchip-rv1106": "",
}


class NixLiteral:
    """Wrapper to insert raw Nix code into the generator output (no quotes)."""

    def __init__(self, value):
        self.value = value

    def __str__(self):
        return self.value


def sanitize_patch_name(name):
    """Make a patch name acceptable as a Nix store name.

    Nix rejects ``&``, ``,``, spaces and most punctuation in a store path name.
    These characters come from Armbian patches (e.g.
    ``...led-gpio&keyboard.patch``) and made some U-Boot packages fail to
    evaluate. They are replaced with ``_`` in the copied path; the patch content
    and the order in ``series.conf`` are unchanged.
    """
    return re.sub(r"[^A-Za-z0-9+_.?=-]", "_", name)


class NixGenerator:
    def __init__(self, armbian_src, out_dir, armbian_version=None):
        self.src = Path(armbian_src).resolve()
        self.out_dir = Path(out_dir).resolve()
        # Armbian version from the pin (versions.json). It must NOT be read from
        # the tree's VERSION file: on tag v26.5.1 it is "26.05.0-trunk"
        # (verified). None = unlabeled metadata.
        self.armbian_version = armbian_version
        self.nix_out = self.out_dir / "nix"
        self.patches_out = self.nix_out / "patches"
        self.families_out = self.nix_out / "families"
        self.templates_dir = Path(__file__).parent / "templates"
        # Kernel configs declared but absent from the Armbian source (deduplicate warnings)
        self._missing_kernel_configs: set[str] = set()
        # Cache (component, patch_dir) -> ordered list of already-copied patches.
        # ~737 boards reuse the same (family, branch): without this cache we would
        # recopy 480 files for every board.
        self._patch_dir_cache: dict[tuple[str, str], list[str]] = {}

        # Ensure directories exist
        self.nix_out.mkdir(parents=True, exist_ok=True)
        self.patches_out.mkdir(parents=True, exist_ok=True)
        self.families_out.mkdir(parents=True, exist_ok=True)

    def _add_nvfetcher_keys(
        self, family, kernel_dict=None, uboot_dict=None, firmware_dict=None
    ):
        if kernel_dict is not None:
            if kernel_dict.get("source") and kernel_dict.get("branch"):
                kernel_dict["nvfetcher_key"] = sanitize_name(
                    f"kernel-{family}-{kernel_dict['branch']}"
                )
        if uboot_dict is not None:
            if uboot_dict.get("source") and uboot_dict.get("branch"):
                uboot_dict["nvfetcher_key"] = sanitize_name(
                    f"uboot-{uboot_dict['branch']}"
                )
            if uboot_dict.get("atf_source") and uboot_dict.get("atf_branch"):
                repo_name = uboot_dict["atf_source"].split("/")[-1].replace(".git", "")
                uboot_dict["atf_nvfetcher_key"] = sanitize_name(
                    f"src-{repo_name}-{uboot_dict['atf_branch']}"
                )
        if firmware_dict is not None:
            if firmware_dict.get("source") and firmware_dict.get("branch"):
                repo_name = firmware_dict["source"].split("/")[-1].replace(".git", "")
                firmware_dict["nvfetcher_key"] = sanitize_name(
                    f"src-{repo_name}-{firmware_dict['branch']}"
                )

    def generate(self, board_metadata_list):
        """Generates Nix files and collects assets."""
        log.info(f"Generating Nix expressions in {self.nix_out}")

        # A family or board removed between Armbian versions must not survive in
        # metadata/: without pruning, orphan files keep store paths from the
        # previous generation.
        if self.families_out.exists():
            shutil.rmtree(self.families_out)
        self.families_out.mkdir(parents=True)

        family_data = {}  # family -> { 'platforms': {}, 'boards': {} }
        board_index = {}  # board -> family

        for board_info in board_metadata_list:
            board_name = board_info["board"]
            branch = board_info["branch"]
            family = board_info["linux_family"] or "generic"
            # (b) Version label: supplied by the pin, never by the Armbian tree's
            # VERSION file (26.05.0-trunk on v26.5.1).
            if self.armbian_version is not None:
                board_info["armbian_version"] = self.armbian_version

            if family not in family_data:
                family_data[family] = {"platforms": {}, "boards": {}}

            plat_key = f"{family}-{branch}"
            board_key = f"{board_name}-{branch}"

            # Index global mapping
            board_index[board_key] = {
                "family": family,
                "board": board_name,
                "branch": branch,
                "arch": board_info["arch"],
            }

            # Asset Collection
            self._collect_kernel_config(board_info)
            self._collect_patches(board_info, "kernel")
            self._collect_patches(board_info, "uboot")

            # Build platform data
            if plat_key not in family_data[family]["platforms"]:
                kernel_data = board_info["kernel"].copy()
                uboot_data = board_info["uboot"].copy()
                firmware_data = (
                    board_info["firmware"].copy() if board_info.get("firmware") else {}
                )
                self._add_nvfetcher_keys(family, kernel_data, uboot_data, firmware_data)
                family_data[family]["platforms"][plat_key] = {
                    "linux_family": board_info["linux_family"],
                    "branch": branch,
                    "arch": board_info["arch"],
                    "kernel": kernel_data,
                    "uboot": uboot_data,
                    "firmware": firmware_data,
                }

            # Build board data
            # Calculate overrides for uboot, kernel, and firmware to avoid wiping platform defaults
            uboot_overrides = {}
            platform_uboot = family_data[family]["platforms"][plat_key]["uboot"]
            for k, v in board_info["uboot"].items():
                if v is not None and v != platform_uboot.get(k):
                    uboot_overrides[k] = v

            kernel_overrides = {}
            platform_kernel = family_data[family]["platforms"][plat_key]["kernel"]
            for k, v in board_info["kernel"].items():
                if v is not None and v != platform_kernel.get(k):
                    kernel_overrides[k] = v

            firmware_overrides = {}
            platform_firmware = family_data[family]["platforms"][plat_key].get(
                "firmware", {}
            )
            if board_info.get("firmware"):
                for k, v in board_info["firmware"].items():
                    if v is not None and v != platform_firmware.get(k):
                        firmware_overrides[k] = v

            # If overrides exist and change branches/sources, compute keys for the overrides
            if uboot_overrides:
                temp_uboot = platform_uboot.copy()
                temp_uboot.update(uboot_overrides)
                self._add_nvfetcher_keys(family, uboot_dict=temp_uboot)
                for k in ["nvfetcher_key", "atf_nvfetcher_key"]:
                    if k in temp_uboot and temp_uboot[k] != platform_uboot.get(k):
                        uboot_overrides[k] = temp_uboot[k]

            if kernel_overrides:
                temp_kernel = platform_kernel.copy()
                temp_kernel.update(kernel_overrides)
                self._add_nvfetcher_keys(family, kernel_dict=temp_kernel)
                if "nvfetcher_key" in temp_kernel and temp_kernel[
                    "nvfetcher_key"
                ] != platform_kernel.get("nvfetcher_key"):
                    kernel_overrides["nvfetcher_key"] = temp_kernel["nvfetcher_key"]

            if firmware_overrides:
                temp_firmware = platform_firmware.copy()
                temp_firmware.update(firmware_overrides)
                self._add_nvfetcher_keys(family, firmware_dict=temp_firmware)
                if "nvfetcher_key" in temp_firmware and temp_firmware[
                    "nvfetcher_key"
                ] != platform_firmware.get("nvfetcher_key"):
                    firmware_overrides["nvfetcher_key"] = temp_firmware["nvfetcher_key"]

            family_data[family]["boards"][board_key] = {
                "inherit": NixLiteral(f'platforms."{plat_key}"'),
                "board": board_name,
                "uboot": uboot_overrides,
                "kernel": kernel_overrides,
                "firmware": firmware_overrides,
                "dtb": board_info.get("dtb"),
                "kernel_params": board_info.get("kernel_params"),
                "firmware_include": board_info.get("firmware_include"),
                "family": family,
            }

        families = sorted(family_data.keys())
        self.write_families_index(families)

        for family, data in family_data.items():
            self.write_family_dir(family, data)

        # Write global board index
        (self.out_dir / "boards.json").write_text(
            json.dumps(board_index, indent=4) + "\n"
        )

        self.write_library_nix()

    def write_families_index(self, families):
        """Writes families/default.nix to index all family directories."""
        lines = [f'  "{f}" = import ./{f};' for f in families]
        content = "{\n" + "\n".join(lines) + "\n}"
        (self.families_out / "default.nix").write_text(content + "\n")

    def write_family_dir(self, family, data):
        """Generates families/<family>/ structure."""
        fam_dir = self.families_out / family
        boards_dir = fam_dir / "boards"
        fam_dir.mkdir(parents=True, exist_ok=True)
        boards_dir.mkdir(parents=True, exist_ok=True)

        # 1. platforms.nix
        plat_nix = self.to_nix(data["platforms"])
        (fam_dir / "platforms.nix").write_text(plat_nix + "\n")

        # 2. boards/*.nix
        board_names = []
        for board_key, board_val in data["boards"].items():
            inherit = board_val.pop("inherit")
            # We use lib.recursiveUpdate to avoid shallow merge destroying nested dicts (uboot, kernel)
            content = f"{{ platforms, lib }}: lib.recursiveUpdate {inherit} {self.to_nix(board_val, indent=0)}"
            (boards_dir / f"{board_key}.nix").write_text(content + "\n")
            board_names.append(board_key)

        # 3. default.nix (The Entry Point)
        board_imports = "\n".join(
            [
                f'  "{b}" = import ./boards/{b}.nix {{ inherit platforms lib; }};'
                for b in board_names
            ]
        )
        index_content = f"""# Generated by Nixbian
let
  platforms = import ./platforms.nix;
in
{{ lib }}:
{{
{board_imports}
}}
"""
        (fam_dir / "default.nix").write_text(index_content + "\n")

        # 4. package.nix (Hardware Package)
        # (b) Armbian version stamped into the package (passthru), default frozen
        # from the pin by the generator; the argument remains overridable.
        armbian_version_nix = (
            f'"{self.armbian_version}"' if self.armbian_version is not None else "null"
        )
        # Family .config fragment (defconfig tier): Nix string "" or ''...''
        family_fragment = FAMILY_CONFIG_FRAGMENTS.get(family, "")
        if family_fragment:
            fragment_body = "".join(
                f"        {line}\n" for line in family_fragment.splitlines()
            )
            family_config = f"''\n{fragment_body}      ''"
        else:
            family_config = '""'
        package_content = f"""{{ pkgs, helpers, sources, atf ? null, armbianVersion ? {armbian_version_nix} }}:
let
  platforms = import ./platforms.nix;
  lib = pkgs.lib;
  boards = import ./default.nix {{ inherit lib; }};

  # Helper to inject source derivations from nvfetcher into metadata
  injectHashes = meta:
    let
      kSourceKey = meta.kernel.nvfetcher_key or null;
      uSourceKey = meta.uboot.nvfetcher_key or null;
      aSourceKey = meta.uboot.atf_nvfetcher_key or null;
      fSourceKey = meta.firmware.nvfetcher_key or null;

      kSource = if kSourceKey != null then sources.${{kSourceKey}} or null else null;
      uSource = if uSourceKey != null then sources.${{uSourceKey}} or null else null;
      aSource = if aSourceKey != null then sources.${{aSourceKey}} or null else null;
      fSource = if fSourceKey != null then sources.${{fSourceKey}} or null else null;
    in
    lib.recursiveUpdate meta {{
      kernel.src = if kSource != null then kSource.src else null;
      uboot.src = if uSource != null then uSource.src else null;
      uboot.atf_src = if aSource != null then aSource.src else null;
      firmware.src = if fSource != null then fSource.src else null;
    }};

  # Collect the unique DTBs of all boards sharing the same family+branch.
  # Avoids building ~400 ARM64 DTBs when only a few are needed.
  # Used by library.nix -> buildKernel -> dtb_list.
  platformDtbs = lib.mapAttrs (name: meta:
    let
      # Platform family (boards without linux_family live in "generic")
      family = if (meta.linux_family or null) == null then "generic" else meta.linux_family;
      branch = meta.kernel.branch or "";
      matching = lib.filterAttrs (_: b:
        (b.family or "generic") == family
        && (b.kernel.branch or "") == branch
        && (b.dtb or null) != null
      ) boards;
    in
    lib.unique (builtins.map (b: b.dtb) (builtins.attrValues matching))
  ) platforms;

  # Dynamically fetch the correct package set and helpers based on target architecture
  getPkgsAndHelpers =
    arch:
    if arch == "arm64" then
      let
        p =
          if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
            pkgs
          else
            pkgs.pkgsCross.aarch64-multiplatform;
        h = import ../../library.nix {{ pkgs = p; }};
      in
      {{
        pkgs = p;
        helpers = h;
      }}
    else if arch == "armhf" then
      let
        p =
          if pkgs.stdenv.hostPlatform.system == "armv7l-linux" then
            pkgs
          else
            pkgs.pkgsCross.armv7l-hf-multiplatform;
        h = import ../../library.nix {{ pkgs = p; }};
      in
      {{
        pkgs = p;
        helpers = h;
      }}
    else
      {{ inherit pkgs helpers; }};

in rec {{
  # Default kernels: armbian tier (full Armbian .config) — production default
  kernels = lib.mapAttrs (name: meta:
    let
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      # Inject DTBs specific to this platform (buildDTBs optimization)
      dtbs = platformDtbs.${{name}} or [];
      metaWithDtbs = if dtbs != [] then
        lib.recursiveUpdate (injectHashes meta) {{
          dtb_list = dtbs;
        }}
      else
        injectHashes meta;
      # Armbian tier if an Armbian config was collected for the family,
      # otherwise fall back to nixpkgs (enableCommonConfig): "armbian" + empty
      # config would disable the common nixpkgs config without replacing it.
      hasArmbianConfig = ((meta.kernel or {{}}).config_path_nix or null) != null;
      k = ph.helpers.buildKernel (metaWithDtbs // {{
        configMode = if hasArmbianConfig then "armbian" else "nixpkgs";
      }});
      kernelPatchList = (meta.kernel or {{}}).patches or [];
    in
    if k != null then k // {{ passthru = (k.passthru or {{}}) // {{
      patches = kernelPatchList;
      inherit armbianVersion;
      inherit (meta) branch;
      linuxFamily =
        if (meta.linux_family or null) != null then meta.linux_family else "generic";
      platformKey = name;
    }}; }} else null
  ) platforms;

  # defconfig-tier kernels: platform defconfig + family .config fragment
  defconfigKernels = lib.mapAttrs (name: meta:
    let
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      # Inject DTBs specific to this platform (buildDTBs optimization)
      dtbs = platformDtbs.${{name}} or [];
      metaWithDtbs = if dtbs != [] then
        lib.recursiveUpdate (injectHashes meta) {{
          dtb_list = dtbs;
        }}
      else
        injectHashes meta;
    in
    let
      k = ph.helpers.buildKernel (metaWithDtbs // {{
        configMode = "defconfig";
        familyConfig = {family_config};
      }});
    in
    if k != null then k // {{ passthru = (k.passthru or {{}}) // {{
      inherit armbianVersion;
      inherit (meta) branch;
      linuxFamily =
        if (meta.linux_family or null) != null then meta.linux_family else "generic";
      platformKey = name;
    }}; }} else null
  ) platforms;

  uBoots = pkgs.lib.mapAttrs (name: meta:
    let
      metaWithHashes = injectHashes meta;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      atf = if (metaWithHashes.uboot.atf_source or null) != null then
        ph.helpers.buildATF {{
          inherit meta;
          src = if metaWithHashes.uboot ? atf_src && metaWithHashes.uboot.atf_src != null
                then metaWithHashes.uboot.atf_src
                else ph.helpers.fetchSource {{
                   url = metaWithHashes.uboot.atf_source;
                   rev = metaWithHashes.uboot.atf_branch;
                   hash = metaWithHashes.uboot.atf_hash or null;
                }};
          version = metaWithHashes.uboot.atf_branch or "custom";
        }}
      else null;
    in
    let
      ub = ph.helpers.buildUBoot {{
        inherit meta;
        inherit atf;
        src = if metaWithHashes.uboot ? src && metaWithHashes.uboot.src != null
              then metaWithHashes.uboot.src
              else ph.helpers.fetchSource {{
                url = metaWithHashes.uboot.source;
                rev = metaWithHashes.uboot.branch;
                hash = metaWithHashes.uboot.source_hash or null;
              }};
        version = metaWithHashes.uboot.branch or "custom";
      }};
      ubootPatchList = (metaWithHashes.uboot or {{}}).patches or [];
    in
    if ub != null then ub // {{ passthru = (ub.passthru or {{}}) // {{
      patches = ubootPatchList;
      inherit armbianVersion;
    }}; }} else null
  ) boards;

  firmwares = pkgs.lib.mapAttrs (name: meta:
    let
      metaWithHashes = injectHashes meta;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      firmwareSrc = if metaWithHashes ? firmware && metaWithHashes.firmware ? src && metaWithHashes.firmware.src != null
                    then metaWithHashes.firmware.src
                    else if (metaWithHashes.firmware.source or null) != null then
                      ph.helpers.fetchSource {{
                        url = metaWithHashes.firmware.source;
                        rev = metaWithHashes.firmware.branch;
                        hash = metaWithHashes.firmware.hash or null;
                      }}
                    else null;
      fwSrcs = (if firmwareSrc != null then [ firmwareSrc ] else [ sources.src-firmware-master.src ])
               ++ [ sources.src-armbian-build.src ];
    in
    let
      fw = ph.helpers.buildFirmware {{
        inherit (meta) family;
        srcs = fwSrcs;
        include = meta.firmware_include or null;
      }};
    in
    if fw != null then fw // {{ passthru = (fw.passthru or {{}}) // {{ inherit armbianVersion; }}; }} else null
  ) boards;

  # L5 — per-board filtered modules tree: cheap derivation on the shared tree
  # (no kernel rebuild). `kernelModulesFor` takes the host allowlist;
  # `kernelModules` applies the default policy (core + DTB + closure).
  kernelModulesFor = lib.mapAttrs (boardKey: b:
    {{ extraKeep ? [ ], extraKeepPaths ? [ ] }}:
    let
      meta = injectHashes b;
      familyKey =
        if (meta.linux_family or null) != null then meta.linux_family
        else (meta.family or "generic");
      platformKey = "${{familyKey}}-${{meta.branch or "current"}}";
      kernel = kernels.${{platformKey}} or null;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      dtb = meta.dtb or null;
    in
    if kernel == null || dtb == null then null
    else ph.helpers.pruneKernelModules {{
      name = "linux-modules-${{boardKey}}-pruned";
      kernelOut = kernel;
      modules = kernel.modules;
      dtb = "${{kernel}}/dtbs/${{dtb}}";
      inherit extraKeep extraKeepPaths;
    }}
  ) boards;

  kernelModules = lib.mapAttrs (boardKey: f: f {{ }}) kernelModulesFor;

  # Sources: standalone fetch derivations (buildable without building the full kernel).
  # kernelSrcs.<name> = fetchgit derivation; ubootSrcs.<name> = fetchgit derivation.
  kernelSrcs = lib.mapAttrs (name: meta:
    let
      kSourceKey = meta.kernel.nvfetcher_key or null;
      kSource = if kSourceKey != null then sources.${{kSourceKey}} or null else null;
    in
    if kSource != null then kSource.src else null
  ) platforms;

  ubootSrcs = lib.mapAttrs (name: meta:
    let
      uSourceKey = meta.uboot.nvfetcher_key or null;
      uSource = if uSourceKey != null then sources.${{uSourceKey}} or null else null;
    in
    if uSource != null then uSource.src else null
  ) boards;

  # Patches: metadata lists (relative paths, not builds).
  kernelPatches = lib.mapAttrs (name: meta:
    if builtins.isList ((meta.kernel or {{}}).patches or [])
    then (meta.kernel or {{}}).patches else []
  ) platforms;

  ubootPatches = lib.mapAttrs (name: meta:
    if builtins.isList ((meta.uboot or {{}}).patches or [])
    then (meta.uboot or {{}}).patches else []
  ) boards;
}}
"""
        (fam_dir / "package.nix").write_text(package_content + "\n")

        # 5. metadata.json (for discovery)
        metadata = {
            "family": family,
            "platforms": {
                k: {"arch": v["arch"], "branch": v["branch"]}
                for k, v in data["platforms"].items()
            },
        }
        (fam_dir / "metadata.json").write_text(json.dumps(metadata, indent=4) + "\n")

    def _collect_kernel_config(self, board_info):
        """Copies kernel config if it exists."""
        family = board_info["linux_family"] or "generic"
        family_configs_out = self.families_out / family / "configs"
        family_configs_out.mkdir(parents=True, exist_ok=True)

        if board_info["kernel"]["config_path"]:
            conf_path = Path(board_info["kernel"]["config_path"])
            # Recent metadata carries a path relative to the Armbian tree;
            # older metadata carries an absolute path. Both must work during a
            # regeneration.
            if not conf_path.is_absolute():
                conf_path = self.src / conf_path
            if conf_path.exists():
                dest_path = family_configs_out / conf_path.name
                if not dest_path.exists():
                    log.debug(f"Copying kernel config for {family}: {conf_path.name}")
                    shutil.copy(conf_path, dest_path)

                # (c) The raw Armbian .config is the single reference config:
                # conversion to Nix attributes (config_struct_nix) was removed —
                # it had no consumer.
                board_info["kernel"]["config_path_nix"] = f"configs/{conf_path.name}"
            elif conf_path.name not in self._missing_kernel_configs:
                # Strong signal: without a config, the armbian tier would fall back to empty.
                self._missing_kernel_configs.add(conf_path.name)
                log.warning(
                    f"Kernel config not found for {family}: {conf_path} "
                    f"(armbian tier unavailable -> falling back to nixpkgs)"
                )

    @staticmethod
    def _read_series(patch_root):
        """Read `series.conf` (Armbian application order, one path per line).

        Returns ``(active, disabled)`` or ``None`` if the directory has no
        series.conf. Lines starting with ``-`` are disabled upstream (the file
        remains on disk but is not applied).
        """
        series = patch_root / "series.conf"
        if not series.is_file():
            return None
        active, disabled = [], []
        for raw in series.read_text(errors="replace").splitlines():
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            if line.startswith("-"):
                disabled.append(line[1:].strip())
            else:
                active.append(line)
        return active, disabled

    def _collect_patch_dir(self, component, patch_rel):
        """Copy an Armbian patch directory and return its ordered list.

        Recent sets (sunxi, filogic) store patches in subdirectories
        (`patches.armbian/`, `patches.drm/`, `patches.megous/`…) and describe
        the order in `series.conf`. A non-recursive glob over these directories
        finds nothing and silently produces zero patches — a "the armbian tier"
        kernel built without any patch still builds, so the error is invisible.
        We therefore walk recursively, honor series.conf when present, and keep
        the relative tree (two subdirectories may contain the same filename).
        """
        key = (component, patch_rel)
        if key in self._patch_dir_cache:
            return self._patch_dir_cache[key]

        dir_name = "u-boot" if component == "uboot" else component
        patch_root = self.src / "patch" / dir_name / patch_rel
        out_paths: list[str] = []
        if not (patch_root.is_dir()):
            log.warning(f"Patch directory not found: {patch_root}")
            self._patch_dir_cache[key] = out_paths
            return out_paths

        dest_dir = self.patches_out / component / patch_rel
        dest_dir.mkdir(parents=True, exist_ok=True)

        on_disk = {str(p.relative_to(patch_root)) for p in patch_root.rglob("*.patch")}
        series = self._read_series(patch_root)
        if series is None:
            rels = sorted(on_disk)
            detail = "alphabetical order (no series.conf)"
        else:
            active, disabled = series
            rels = [r for r in dict.fromkeys(active) if r not in disabled]
            missing = [r for r in rels if r not in on_disk]
            unlisted = sorted(on_disk - set(active) - set(disabled))
            if missing:
                log.warning(
                    f"{component}/{patch_rel}: {len(missing)} patch(es) listed "
                    f"in series.conf but missing from disk "
                    f"(e.g. {missing[0]})"
                )
            detail = f"series.conf order ({len(disabled)} disabled)"
            if unlisted:
                detail += f", {len(unlisted)} unlisted ignored"

        for rel in rels:
            rel_path = Path(rel)
            if rel_path.is_absolute() or ".." in rel_path.parts:
                log.warning(f"{component}/{patch_rel}: path rejected {rel!r}")
                continue
            src_p = patch_root / rel_path
            if not src_p.is_file():
                continue
            # Nix rejects some characters in store names (e.g. "&"). Keep the
            # series.conf order but sanitize the copied path.
            dest_rel = Path(*[sanitize_patch_name(part) for part in rel_path.parts])
            dest_p = dest_dir / dest_rel
            dest_p.parent.mkdir(parents=True, exist_ok=True)
            # Unconditional copy: if Armbian changes a patch while keeping its
            # filename, a "copy only if absent" strategy would keep the old one.
            shutil.copyfile(src_p, dest_p)
            out_paths.append(f"patches/{component}/{patch_rel}/{dest_rel.as_posix()}")

        log.info(
            f"{component}/{patch_rel}: {len(out_paths)} patch(es) collected — {detail}"
        )
        self._patch_dir_cache[key] = out_paths
        return out_paths

    def _collect_patches(self, board_info, component):
        """Collects patch files and generates an ordered list."""
        patch_dir_key = "patch_dir"
        patch_dir = board_info[component].get(patch_dir_key) if patch_dir_key else None
        if not patch_dir:
            return
        all_patches: list[str] = []
        for patch_rel in patch_dir.split():
            all_patches.extend(self._collect_patch_dir(component, patch_rel))

        # Deduplicate while preserving order (two patch_dirs may overlap).
        board_info[component]["patches"] = list(dict.fromkeys(all_patches))

    def _apply_template(self, template_name, data_content):
        """Reads a template and replaces the <@ DATA @> marker."""
        template_file = self.templates_dir / f"{template_name}.nix"
        if not template_file.exists():
            log.warning(f"Template {template_name} not found.")
            return f"{{\n{data_content}\n}}"

        template_text = template_file.read_text()
        return template_text.replace("<@ DATA @>", data_content)

    def write_library_nix(self):
        """Writes library.nix utilizing templates."""

        def safe_copy(src, dst):
            dst = Path(dst)
            if dst.exists():
                try:
                    dst.chmod(0o644)
                except Exception:
                    pass
                try:
                    dst.unlink()
                except Exception:
                    pass
            shutil.copy(src, dst)
            try:
                dst.chmod(0o644)
            except Exception:
                pass

        lib_file = self.nix_out / "library.nix"
        template = self.templates_dir / "library.nix"
        if template.exists():
            safe_copy(template, lib_file)

        # Also copy firmware.nix
        fw_file = self.nix_out / "firmware.nix"
        fw_template = self.templates_dir / "firmware.nix"
        if fw_template.exists():
            safe_copy(fw_template, fw_file)

        # L5 — library.nix's pruneKernelModules helper calls this script
        # (relative path ./prune_modules.py from metadata/nix/).
        prune_script = Path(__file__).parent / "prune_modules.py"
        if prune_script.exists():
            safe_copy(prune_script, self.nix_out / "prune_modules.py")

    @staticmethod
    def stamp_armbian_version(metadata_list, armbian_version):
        """(b) Stamp every board_metadata.json entry.

        The version comes from the pin (`versions.json`), never from the
        Armbian tree's VERSION file ("26.05.0-trunk" on tag v26.5.1).
        Returns the number of stamped entries (0 if the version is absent).
        """
        if armbian_version is None:
            return 0
        for entry in metadata_list:
            if isinstance(entry, dict):
                entry["armbian_version"] = armbian_version
        return len(metadata_list)

    @staticmethod
    def to_nix(obj, indent=0):
        """Converts Python object to a Nix expression string."""
        if isinstance(obj, NixLiteral):
            return str(obj)
        elif isinstance(obj, dict):
            lines = ["{"]
            # Sort keys for deterministic output
            for k in sorted(obj.keys()):
                v = obj[k]
                nix_key = (
                    f'"{k}"'
                    if not k.replace("_", "").isalnum() or k[0].isdigit()
                    else k
                )
                lines.append(
                    f"{' ' * (indent + 2)}{nix_key} = {NixGenerator.to_nix(v, indent + 2)};"
                )
            lines.append(f"{' ' * indent}}}")
            return "\n".join(lines)
        elif isinstance(obj, list):
            if not obj:
                return "[]"
            items = [NixGenerator.to_nix(i, indent + 2) for i in obj]
            return f"[ {' '.join(items)} ]"
        elif isinstance(obj, (str, Path)):
            s = str(obj)
            escaped = s.replace('"', '\\"').replace("${", "\\${")
            return f'"{escaped}"'
        elif isinstance(obj, bool):
            return str(obj).lower()
        elif obj is None:
            return "null"
        else:
            return str(obj)
