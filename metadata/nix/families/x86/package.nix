{
  pkgs,
  helpers,
  sources,
  atf ? null,
  armbianVersion ? "v26.5.1",
}:
let
  platforms = import ./platforms.nix;
  lib = pkgs.lib;
  boards = import ./default.nix { inherit lib; };

  # Helper to inject source derivations from nvfetcher into metadata
  injectHashes =
    meta:
    let
      kSourceKey = meta.kernel.nvfetcher_key or null;
      uSourceKey = meta.uboot.nvfetcher_key or null;
      aSourceKey = meta.uboot.atf_nvfetcher_key or null;
      fSourceKey = meta.firmware.nvfetcher_key or null;

      kSource = if kSourceKey != null then sources.${kSourceKey} or null else null;
      uSource = if uSourceKey != null then sources.${uSourceKey} or null else null;
      aSource = if aSourceKey != null then sources.${aSourceKey} or null else null;
      fSource = if fSourceKey != null then sources.${fSourceKey} or null else null;
    in
    lib.recursiveUpdate meta {
      kernel.src = if kSource != null then kSource.src else null;
      uboot.src = if uSource != null then uSource.src else null;
      uboot.atf_src = if aSource != null then aSource.src else null;
      firmware.src = if fSource != null then fSource.src else null;
    };

  # Collect the unique DTBs of all boards sharing the same family+branch.
  # Avoids building ~400 ARM64 DTBs when only a few are needed.
  # Used by library.nix -> buildKernel -> dtb_list.
  platformDtbs = lib.mapAttrs (
    name: meta:
    let
      # Platform family (boards without linux_family live in "generic")
      family = if (meta.linux_family or null) == null then "generic" else meta.linux_family;
      branch = meta.kernel.branch or "";
      matching = lib.filterAttrs (
        _: b:
        (b.family or "generic") == family && (b.kernel.branch or "") == branch && (b.dtb or null) != null
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
        h = import ../../library.nix { pkgs = p; };
      in
      {
        pkgs = p;
        helpers = h;
      }
    else if arch == "armhf" then
      let
        p =
          if pkgs.stdenv.hostPlatform.system == "armv7l-linux" then
            pkgs
          else
            pkgs.pkgsCross.armv7l-hf-multiplatform;
        h = import ../../library.nix { pkgs = p; };
      in
      {
        pkgs = p;
        helpers = h;
      }
    else
      { inherit pkgs helpers; };

in
rec {
  # Default kernels: armbian tier (full Armbian .config) — production default
  kernels = lib.mapAttrs (
    name: meta:
    let
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      # Inject DTBs specific to this platform (buildDTBs optimization)
      dtbs = platformDtbs.${name} or [ ];
      metaWithDtbs =
        if dtbs != [ ] then
          lib.recursiveUpdate (injectHashes meta) {
            dtb_list = dtbs;
          }
        else
          injectHashes meta;
      # Armbian tier if an Armbian config was collected for the family,
      # otherwise fall back to nixpkgs (enableCommonConfig): "armbian" + empty
      # config would disable the common nixpkgs config without replacing it.
      hasArmbianConfig = ((meta.kernel or { }).config_path_nix or null) != null;
      k = ph.helpers.buildKernel (
        metaWithDtbs
        // {
          configMode = if hasArmbianConfig then "armbian" else "nixpkgs";
        }
      );
      kernelPatchList = (meta.kernel or { }).patches or [ ];
    in
    if k != null then
      k
      // {
        passthru = (k.passthru or { }) // {
          patches = kernelPatchList;
          inherit armbianVersion;
          inherit (meta) branch;
          linuxFamily = if (meta.linux_family or null) != null then meta.linux_family else "generic";
          platformKey = name;
        };
      }
    else
      null
  ) platforms;

  # defconfig-tier kernels: platform defconfig + family .config fragment
  defconfigKernels = lib.mapAttrs (
    name: meta:
    let
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      # Inject DTBs specific to this platform (buildDTBs optimization)
      dtbs = platformDtbs.${name} or [ ];
      metaWithDtbs =
        if dtbs != [ ] then
          lib.recursiveUpdate (injectHashes meta) {
            dtb_list = dtbs;
          }
        else
          injectHashes meta;
    in
    let
      k = ph.helpers.buildKernel (
        metaWithDtbs
        // {
          configMode = "defconfig";
          familyConfig = "";
        }
      );
    in
    if k != null then
      k
      // {
        passthru = (k.passthru or { }) // {
          inherit armbianVersion;
          inherit (meta) branch;
          linuxFamily = if (meta.linux_family or null) != null then meta.linux_family else "generic";
          platformKey = name;
        };
      }
    else
      null
  ) platforms;

  uBoots = pkgs.lib.mapAttrs (
    name: meta:
    let
      metaWithHashes = injectHashes meta;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      atf =
        if (metaWithHashes.uboot.atf_source or null) != null then
          ph.helpers.buildATF {
            inherit meta;
            src =
              if metaWithHashes.uboot ? atf_src && metaWithHashes.uboot.atf_src != null then
                metaWithHashes.uboot.atf_src
              else
                ph.helpers.fetchSource {
                  url = metaWithHashes.uboot.atf_source;
                  rev = metaWithHashes.uboot.atf_branch;
                  hash = metaWithHashes.uboot.atf_hash or null;
                };
            version = metaWithHashes.uboot.atf_branch or "custom";
          }
        else
          null;
    in
    let
      ub = ph.helpers.buildUBoot {
        inherit meta;
        inherit atf;
        src =
          if metaWithHashes.uboot ? src && metaWithHashes.uboot.src != null then
            metaWithHashes.uboot.src
          else
            ph.helpers.fetchSource {
              url = metaWithHashes.uboot.source;
              rev = metaWithHashes.uboot.branch;
              hash = metaWithHashes.uboot.source_hash or null;
            };
        version = metaWithHashes.uboot.branch or "custom";
      };
      ubootPatchList = (metaWithHashes.uboot or { }).patches or [ ];
    in
    if ub != null then
      ub
      // {
        passthru = (ub.passthru or { }) // {
          patches = ubootPatchList;
          inherit armbianVersion;
        };
      }
    else
      null
  ) boards;

  firmwares = pkgs.lib.mapAttrs (
    name: meta:
    let
      metaWithHashes = injectHashes meta;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      firmwareSrc =
        if
          metaWithHashes ? firmware && metaWithHashes.firmware ? src && metaWithHashes.firmware.src != null
        then
          metaWithHashes.firmware.src
        else if (metaWithHashes.firmware.source or null) != null then
          ph.helpers.fetchSource {
            url = metaWithHashes.firmware.source;
            rev = metaWithHashes.firmware.branch;
            hash = metaWithHashes.firmware.hash or null;
          }
        else
          null;
      fwSrcs = (if firmwareSrc != null then [ firmwareSrc ] else [ sources.src-firmware-master.src ]) ++ [
        sources.src-armbian-build.src
      ];
    in
    let
      fw = ph.helpers.buildFirmware {
        inherit (meta) family;
        srcs = fwSrcs;
        include = meta.firmware_include or null;
      };
    in
    if fw != null then
      fw
      // {
        passthru = (fw.passthru or { }) // {
          inherit armbianVersion;
        };
      }
    else
      null
  ) boards;

  # L5 — per-board filtered modules tree: cheap derivation on the shared tree
  # (no kernel rebuild). `kernelModulesFor` takes the host allowlist;
  # `kernelModules` applies the default policy (core + DTB + closure).
  kernelModulesFor = lib.mapAttrs (
    boardKey: b:
    {
      extraKeep ? [ ],
      extraKeepPaths ? [ ],
    }:
    let
      meta = injectHashes b;
      familyKey =
        if (meta.linux_family or null) != null then meta.linux_family else (meta.family or "generic");
      platformKey = "${familyKey}-${meta.branch or "current"}";
      kernel = kernels.${platformKey} or null;
      ph = getPkgsAndHelpers (meta.arch or "arm64");
      dtb = meta.dtb or null;
    in
    if kernel == null || dtb == null then
      null
    else
      ph.helpers.pruneKernelModules {
        name = "linux-modules-${boardKey}-pruned";
        kernelOut = kernel;
        modules = kernel.modules;
        dtb = "${kernel}/dtbs/${dtb}";
        inherit extraKeep extraKeepPaths;
      }
  ) boards;

  kernelModules = lib.mapAttrs (boardKey: f: f { }) kernelModulesFor;

  # Sources: standalone fetch derivations (buildable without building the full kernel).
  # kernelSrcs.<name> = fetchgit derivation; ubootSrcs.<name> = fetchgit derivation.
  kernelSrcs = lib.mapAttrs (
    name: meta:
    let
      kSourceKey = meta.kernel.nvfetcher_key or null;
      kSource = if kSourceKey != null then sources.${kSourceKey} or null else null;
    in
    if kSource != null then kSource.src else null
  ) platforms;

  ubootSrcs = lib.mapAttrs (
    name: meta:
    let
      uSourceKey = meta.uboot.nvfetcher_key or null;
      uSource = if uSourceKey != null then sources.${uSourceKey} or null else null;
    in
    if uSource != null then uSource.src else null
  ) boards;

  # Patches: metadata lists (relative paths, not builds).
  kernelPatches = lib.mapAttrs (
    name: meta:
    if builtins.isList ((meta.kernel or { }).patches or [ ]) then (meta.kernel or { }).patches else [ ]
  ) platforms;

  ubootPatches = lib.mapAttrs (
    name: meta:
    if builtins.isList ((meta.uboot or { }).patches or [ ]) then (meta.uboot or { }).patches else [ ]
  ) boards;
}
