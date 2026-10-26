{
  pkgs ? import <nixpkgs> { },
}:
let
  lib = pkgs.lib;
in
rec {
  # Helper to get patches as a list of absolute paths
  # Handles both new list-based 'patches' and old directory-based string
  getPatches =
    input:
    if builtins.isList input then
      builtins.map (p: ./. + "/${p}") input
    else if builtins.isString input then
      let
        dir = ./. + "/${input}";
      in
      if builtins.pathExists dir then
        builtins.map (f: dir + "/${f}") (builtins.attrNames (builtins.readDir dir))
      else
        [ ]
    else
      [ ];

  # Helper to apply patches to a Nixpkgs kernel derivation
  # Works with kernel.override { kernelPatches = ... }
  applyPatches =
    kernel: patches:
    kernel.override {
      kernelPatches =
        (kernel.kernelPatches or [ ])
        ++ (builtins.map (p: {
          name = builtins.baseNameOf p;
          patch = p;
        }) patches);
    };

  # High-level helper to build a kernel from armbian metadata
  buildKernel =
    args:
    let
      # Support both passing metadata directly, or passing { meta, extraPatches, excludePatchPatterns }
      meta = if args ? meta then args.meta else args;
      extraPatches = args.extraPatches or [ ];
      excludePatchPatterns = args.excludePatchPatterns or [ ];

      kMeta = meta.kernel;

      # Optional: list of specific DTBs to build (optimisation).
      # If provided, only these DTBs are compiled instead of the ~400 ARM64 ones.
      # The list is collected by the package.nix generator from the boards.
      dtbList = args.dtb_list or null;

      # Kernel configuration mode (3 tiers):
      #   "nixpkgs"   : platform defconfig + nixpkgs common config (enableCommonConfig)
      #   "defconfig" : platform defconfig + family fragment (familyConfig)
      #   "armbian"   : full Armbian .config (production tier, default)
      configMode =
        let
          legacy = args.configType or null; # DEPRECATED: "minimal" -> "defconfig"
        in
        if args ? configMode then
          args.configMode
        else if legacy == null then
          "armbian"
        else if legacy == "minimal" then
          "defconfig"
        else
          legacy;

      # Family .config fragment (CONFIG_X=y syntax), used in defconfig mode
      familyConfig = args.familyConfig or "";

      # Manual user override, added in ALL modes
      userExtraConfig = args.extraConfig or "";

      # Family lines, armbian tier: read from ./family_config.json (verbatim
      # copy of src/armbian_extractor/family_config.json, written by
      # write_library_nix). Keyed by platform, like platforms.nix; the kernel
      # meta carries `config = "linux-<platform>.config"`.
      familyExtraConfigLines =
        let
          declared = builtins.fromJSON (builtins.readFile ./family_config.json);
          platform = lib.removePrefix "linux-" (kMeta.config or "");
        in
        declared.${platform} or [ ];
      familyExtraConfig =
        if familyExtraConfigLines == [ ] then
          ""
        else
          lib.concatStringsSep "\n" familyExtraConfigLines + "\n";

      # Raw Armbian .config ("armbian" mode). config_path_nix is emitted by the
      # generator relative to the family directory
      # (metadata/nix/families/<fam>/configs/...). It is resolved by trying the
      # path as-is from metadata/nix/ (compat), then under
      # families/<linux_family>/; if not found, no fragment ("").
      armbianConfigPath =
        let
          # Family directory: `linux_family` (platforms) or `family`
          # (board overrides, e.g. generic/xpressreal-t3-vendor).
          families = lib.unique (
            lib.filter (f: f != null) [
              (meta.linux_family or null)
              (meta.family or null)
            ]
          );
          candidates = [
            (./. + "/${kMeta.config_path_nix}")
          ]
          ++ map (f: ./. + "/families/${f}/${kMeta.config_path_nix}") families;
          existing = builtins.filter builtins.pathExists candidates;
        in
        if existing != [ ] then builtins.head existing else null;

      # Actually applied mode: if the "armbian" tier is requested but no
      # config was found, fall back to nixpkgs (common config) rather than
      # producing an empty kernel (neither Armbian config nor nixpkgs common config).
      effectiveMode =
        if configMode == "armbian" && armbianConfigPath == null then
          lib.warn "nixbian: armbian tier requested without a usable config — falling back to nixpkgs" "nixpkgs"
        else
          configMode;

      # nixpkgs `extraConfig` is NOT in .config format: generate-config.pl
      # expects "answers" ("SYSVIPC y", "FOO n") — option name WITHOUT the
      # CONFIG_ prefix (cf. lib/kernel.nix / kernel_config.nix), and it *ignores*
      # comments. Both syntaxes are accepted as input (family fragments
      # in .config AND user overrides).
      toKernelAnswers =
        text:
        lib.concatMapStrings (
          rawLine:
          let
            line = lib.trim rawLine;
            notSet = builtins.match "# CONFIG_([A-Za-z0-9_]+) is not set" line;
            assignment = builtins.match "CONFIG_([A-Za-z0-9_]+)=(.*)" line;
            answers = builtins.match "CONFIG_([A-Za-z0-9_]+) (.*\\S)" line;
            bareAnswers = builtins.match "([A-Z][A-Za-z0-9_]*) (.*\\S)" line;
          in
          if line == "" || lib.hasPrefix "#" line then
            (if notSet != null then "${builtins.head notSet} n\n" else "")
          else if assignment != null then
            "${builtins.head assignment} ${builtins.elemAt assignment 1}\n"
          else if answers != null then
            "${builtins.head answers} ${builtins.elemAt answers 1}\n"
          else if bareAnswers != null then
            "${builtins.head bareAnswers} ${builtins.elemAt bareAnswers 1}\n"
          else
            ""
        ) (lib.splitString "\n" text);

      # Effective configuration: fragment of the chosen tier + user override,
      # concatenated then converted to the format expected by generate-config.pl.
      # (Used only by the buildLinux path: the defconfig/nixpkgs tiers.
      #  The armbian tier goes through `configfile`, which does not use answers.)
      effectiveExtraConfig = toKernelAnswers (
        lib.concatStringsSep "\n" (
          lib.filter (s: s != "") [
            (if effectiveMode == "defconfig" then familyConfig else "")
            userExtraConfig
          ]
        )
      );

      # Extract version from branch if possible, else major_minor
      version =
        let
          branch = kMeta.branch or null;
          v =
            if
              branch != null && builtins.stringLength branch >= 5 && builtins.substring 0 5 branch == "tag:v"
            then
              builtins.substring 5 (-1) branch
            else
              kMeta.major_minor or null;
        in
        if v != null then v else "custom";

      src =
        if kMeta ? src && kMeta.src != null then
          kMeta.src
        else
          fetchSource {
            url = kMeta.source;
            rev = kMeta.branch;
            hash = kMeta.hash or null;
          };

      # Extract exact version from Makefile to prevent modDirVersion mismatch
      exactVersion =
        if kMeta ? exact_version && kMeta.exact_version != null then
          kMeta.exact_version
        else
          let
            makefile = src + "/Makefile";
          in
          if src != null && builtins.pathExists (builtins.unsafeDiscardStringContext src + "/Makefile") then
            let
              content = builtins.readFile makefile;
              lines = lib.splitString "\n" content;
              getVar =
                name:
                let
                  matchingLines = lib.filter (l: builtins.match "^${name}[ \t]*=[ \t]*([0-9]+).*" l != null) lines;
                  match =
                    if matchingLines != [ ] then
                      builtins.match "^${name}[ \t]*=[ \t]*([0-9]+).*" (builtins.head matchingLines)
                    else
                      null;
                in
                if match != null then builtins.head match else null;
              v = getVar "VERSION";
              p = getVar "PATCHLEVEL";
              s = getVar "SUBLEVEL";
            in
            if v != null && p != null && s != null then "${v}.${p}.${s}" else version
          else
            version;

      rawPatches = getPatches (kMeta.patches or [ ]);

      # Exclude matches
      filteredPatches = lib.filter (
        p:
        let
          name = builtins.baseNameOf p;
        in
        !(lib.any (re: builtins.match re name != null) excludePatchPatterns)
      ) rawPatches;

      # Concatenate extraPatches
      finalPatches = filteredPatches ++ extraPatches;

    in
    if src == null then
      null
    else
      let
        # Kernel architecture (arm64 / arm / riscv / x86_64…), used to
        # build the arch/<karch>/boot/dts/... paths of the DTBs.
        karch = pkgs.stdenv.hostPlatform.linuxArch;
        # Make targets of the wanted DTBs. They must be RELATIVE to the dts tree
        # (`allwinner/foo.dtb`): the kernel Makefile rule is
        #   %.dtb: dtbs_prepare → $(MAKE) $(build)=$(dtstree) $(dtstree)/$@
        # so passing the full path doubles the prefix and breaks the build
        # ("No rule to make target 'arch/arm64/boot/dts/arch/arm64/...'").
        dtbTargets = pkgs.lib.unique dtbList;

        # Wrapper propagating target and buildDTBs into the derivation AND its passthru
        makeCustomKernel =
          k:
          k
          // {
            inherit (pkgs.stdenv.hostPlatform.linux-kernel) target;
            buildDTBs = if dtbList != null then dtbList else true;
            # Introspection: actually applied mode, and for the armbian tier the
            # config used (path) — used by the `just check-config` gate and
            # by consumers (HavenOS) to verify the effective tier.
            configMode = effectiveMode;
            passthru = (k.passthru or { }) // {
              inherit (pkgs.stdenv.hostPlatform.linux-kernel) target;
              buildDTBs = if dtbList != null then dtbList else true;
              # Requested DTBs (null = all the platform's DTBs)
              dtbs = dtbList;
              configMode = effectiveMode;
              configfile = if effectiveMode == "armbian" then armbianConfigfile else null;
              # Applied family fragment (defconfig tier only) — raw text
              # in .config format, for verification by `just check-config`.
              configFragment = if effectiveMode == "defconfig" then familyConfig else null;
            };
            override = f: makeCustomKernel (k.override f);
            overrideAttrs = f: makeCustomKernel (k.overrideAttrs f);
          }
          // pkgs.lib.optionalAttrs (effectiveMode == "armbian") {
            # Allows `nix build .#kernel-<board>.configfile` (gate): in the armbian
            # tier the kernel "configfile" IS the applied Armbian .config.
            configfile = armbianConfigfile;
          };

        # Common make options (cross + native host tools, cf. HOSTCC)
        kernelMakeFlags =
          pkgs.lib.optional (pkgs.stdenv.cc.targetPrefix != "") "CROSS_COMPILE=${pkgs.stdenv.cc.targetPrefix}"
          ++ pkgs.lib.optional (
            pkgs.stdenv.cc.targetPrefix != ""
          ) "HOSTCC=${pkgs.buildPackages.stdenv.cc}/bin/cc"
          ++ pkgs.lib.optional (
            pkgs.stdenv.cc.targetPrefix != ""
          ) "HOSTCXX=${pkgs.buildPackages.stdenv.cc}/bin/c++";

        kernelPatchArgs = builtins.map (p: {
          name = builtins.baseNameOf p;
          patch = p;
        }) finalPatches;

        kernelExtraMeta = {
          branch = version;
          description = "Linux kernel (${version})";
        };

        # Effective config of the armbian tier. `linuxManualConfig` has no
        # `extraConfig` hook: the family lines and the user override are
        # therefore merged INTO the .config (.config syntax, including
        # "# CONFIG_X is not set") then applied by `make oldconfig`. The family
        # lines come first, the user override last (kconfig keeps the last
        # occurrence). Without either, the family config path is kept
        # (no derivation, hence no import-from-derivation).
        # buildPackages: the .config is a text file, it must not drag the
        # target stdenv in. With `pkgs.writeText` the file was an aarch64
        # derivation, so `nix flake check` on x86_64 (and any eval of a
        # foreign kernel) failed with "platform mismatch". Content unchanged,
        # store path now buildable on the host.
        armbianConfigfile =
          if userExtraConfig == "" && familyExtraConfig == "" then
            armbianConfigPath
          else
            pkgs.buildPackages.writeText "linux-nixbian-${kMeta.config or "family"}.config" (
              (builtins.readFile armbianConfigPath) + "\n" + familyExtraConfig + userExtraConfig + "\n"
            );

        # "armbian" tier: the config is a COMPLETE .config (Armbian
        # savedefconfig). It is passed as `configfile` to linuxManualConfig, which does
        # `ln -sv <config> build/.config` then `make oldconfig` — exactly the
        # Armbian mechanics. (Passing the same file through `extraConfig` would
        # not work: generate-config.pl expects "answers", and y/... answers
        # violate the Kconfig tristate propagation.)
        armbianKernel = pkgs.linuxManualConfig {
          pname = "linux";
          inherit src;
          version = exactVersion;
          modDirVersion = exactVersion;
          configfile = armbianConfigfile;
          allowImportFromDerivation = userExtraConfig != "" || familyExtraConfig != "";
          kernelPatches = kernelPatchArgs;
          randstructSeed = "";
          extraMakeFlags = kernelMakeFlags;
          extraMeta = kernelExtraMeta;
        };

        # "defconfig"/"nixpkgs" tiers: defconfig base (+ nixpkgs common config
        # if nixpkgs mode) + family fragment / user override,
        # passed in "answers" format. autoModules=false outside nixpkgs so that
        # unlisted options keep their Kconfig default instead of turning into
        # modules "at random".
        genericKernel = pkgs.buildLinux {
          inherit src;
          version = exactVersion;
          modDirVersion = exactVersion;

          enableCommonConfig = effectiveMode == "nixpkgs";
          autoModules = effectiveMode == "nixpkgs";
          extraConfig = effectiveExtraConfig;

          kernelPatches = kernelPatchArgs;

          ignoreConfigErrors = true;
          randstructSeed = "";

          extraMakeFlags = kernelMakeFlags;

          # Ensure we don't inherit weird args
          extraMeta = kernelExtraMeta;
        };

        k = if effectiveMode == "armbian" then armbianKernel else genericKernel;

        # Real DTB filtering: only when dtb_list is provided, otherwise
        # upstream nixpkgs behaviour (all DTBs of the defconfig).
        # - buildFlags: drop the "dtbs" target and list the wanted DTBs
        #   explicitly (targets relative to the dts tree, cf. dtbTargets);
        #   NB: `all: dtbs` (under CONFIG_OF_EARLY_FLATTREE) and `vmlinux: dtbs`
        #   (under CONFIG_GENERIC_BUILTIN_DTB, no prompt → disabled on these
        #   platforms) do not apply: buildFlags requests neither "all" nor
        #   "dtbs", so only the listed DTBs are compiled — filtering therefore
        #   acts on the build time *and* on the closure size;
        # - installFlags: drop dtbs_install/INSTALL_DTBS_PATH (dtbs_install
        #   only installs what "dtbs" built through dtbs-list);
        # - postInstall: install the wanted DTBs into $out/dtbs/<relative
        #   path>, same layout as INSTALL_DTBS_PATH.
        customK =
          if dtbList == null then
            k
          else
            k.overrideAttrs (
              final: prev: {
                buildFlags = pkgs.lib.filter (f: f != "dtbs") (prev.buildFlags or [ ]) ++ dtbTargets;
                installFlags = pkgs.lib.filter (
                  f: f != "dtbs_install" && !(pkgs.lib.hasPrefix "INSTALL_DTBS_PATH=" f)
                ) (prev.installFlags or [ ]);
                postInstall = (prev.postInstall or "") + ''
                  ${pkgs.lib.concatMapStrings (d: ''
                    install -D -m 0444 "$buildRoot/arch/${karch}/boot/dts/${d}" "$out/dtbs/${d}"
                  '') dtbList}
                '';
              }
            );
      in
      makeCustomKernel customK;

  # L5 helper — filters the shared `modules` tree of a board.
  #
  # The kernel is NOT rebuilt: the derivation copies the useful modules
  # (base set + DTB compatibles + allowlist + dependency closure) then
  # regenerates the indexes with depmod. The `dtb`, `extraKeep` and
  # `extraKeepPaths` entries make the policy explicit and cacheable.
  pruneKernelModules =
    {
      name ? "kernel-modules-pruned",
      kernelOut,
      modules,
      dtb ? null,
      extraKeep ? [ ],
      extraKeepPaths ? [ ],
    }:
    pkgs.buildPackages.runCommand name
      {
        nativeBuildInputs = with pkgs.buildPackages; [
          python3
          dtc
          kmod
        ];
      }
      ''
        python3 ${./prune_modules.py} \
          --kernel-out ${kernelOut} \
          --modules ${modules} \
          --out $out \
          ${lib.optionalString (dtb != null) "--dtb ${dtb}"} \
          ${lib.concatMapStringsSep " " (k: "--keep ${lib.escapeShellArg k}") extraKeep} \
          ${lib.concatMapStringsSep " " (p: "--keep-path ${p}") extraKeepPaths}
      '';

  # Helper to build ATF
  buildATF =
    {
      meta,
      src,
      version,
    }:
    if (meta.uboot.atf_platform or null) == null then
      null
    else
      pkgs.stdenv.mkDerivation {
        pname = "atf-${meta.board}";
        inherit version src;
        nativeBuildInputs = [ pkgs.buildPackages.binutils ];
        CROSS_COMPILE = "${pkgs.stdenv.cc.targetPrefix}";
        makeFlags = [
          "PLAT=${meta.uboot.atf_platform}"
          "CROSS_COMPILE=${pkgs.stdenv.cc.targetPrefix}"
          "AS=${pkgs.stdenv.cc.targetPrefix}gcc"
          "CC=${pkgs.stdenv.cc.targetPrefix}gcc"
          "LD=${pkgs.stdenv.cc.targetPrefix}ld"
          "AR=${pkgs.stdenv.cc.targetPrefix}ar"
          "NM=${pkgs.stdenv.cc.targetPrefix}nm"
          "OC=${pkgs.stdenv.cc.targetPrefix}objcopy"
          "OD=${pkgs.stdenv.cc.targetPrefix}objdump"
          "DEBUG=1"
          "bl31"
        ];
        preBuild = ''
          echo "=== DEBUG: Environment Info ==="
          echo "CROSS_COMPILE=$CROSS_COMPILE"
          echo "PATH=$PATH"
          type -a ${pkgs.stdenv.cc.targetPrefix}objcopy || echo "Target objcopy not found"
          type -a objcopy || echo "Native objcopy not found"
          ls -la ${pkgs.buildPackages.binutils}/bin
          echo "==============================="
        '';
        installPhase = ''
          mkdir -p $out
          cp build/${meta.uboot.atf_platform}/debug/bl31.bin $out/bl31.bin
        '';
      };

  # Helper to fetch source from Git with optional hash
  fetchSource =
    {
      url,
      rev,
      hash ? null,
    }:
    let
      # Strip tag: prefix for generic fetchers
      cleanRev = if lib.hasPrefix "tag:" rev then lib.removePrefix "tag:" rev else rev;
    in
    if hash != null then
      pkgs.fetchgit {
        inherit url;
        rev = cleanRev;
        sha256 = hash;
      }
    else
      # Placeholder to force a hash error if not building
      null;

  # HACK: Use setuptools 80.10.1 (last version with pkg_resources module).
  # U-Boot v2025.04 binman imports pkg_resources which was REMOVED from
  # setuptools ≥ 82 in nixpkgs (nixpkgs patches it out).
  # Quick fix: fetch older setuptools from PyPI with pkg_resources still present.
  # Long-term fix: when Armbian metadata bumps U-Boot to ≥ v2026.07,
  # Long-term fix: when Armbian bumps U-Boot >= v2026.07,
  # binman will use importlib.resources (stdlib, no more pkg_resources).
  # To remove once the metadata points to v2026.07.
  # and this can be removed.
  ubootPython = pkgs.buildPackages.python3.withPackages (p: [
    p.libfdt
    p.pyelftools
    (p.setuptools.overridePythonAttrs (old: {
      version = "80.10.1";
      src = builtins.fetchurl {
        url = "https://files.pythonhosted.org/packages/source/s/setuptools/setuptools-80.10.1.tar.gz";
        sha256 = "0fkh359pzkckzx2y08jwxhqr2wyvbqdana5xlfc34k0lp0z52bmz";
      };
      doCheck = false;
    }))
  ]);
  ubootNativeBuildInputs = [
    ubootPython
  ];

  # Helper to build U-Boot
  buildUBoot =
    {
      meta,
      src,
      version,
      atf ? null,
    }:
    if (meta.uboot.config or null) == null then
      null
    else
      let
        patches = getPatches (meta.uboot.patches or [ ]);
        version' = if version != null then version else "custom";
      in
      pkgs.buildUBoot {
        defconfig = meta.uboot.config;
        extraMeta.platforms =
          let
            mapArch =
              a:
              if a == "arm64" then
                "aarch64-linux"
              else if a == "armhf" then
                "armv7l-linux"
              else if a == "amd64" then
                "x86_64-linux"
              else if a == "riscv64" then
                "riscv64-linux"
              else if a == "loong64" then
                "loongarch64-linux"
              else
                a;
          in
          [ (mapArch meta.arch) ];
        inherit src;
        version = version';
        extraPatches = patches;
        BL31 = if atf != null then "${atf}/bl31.bin" else null;
        makeFlags = [
          "CROSS_COMPILE=${pkgs.stdenv.cc.targetPrefix}"
          "HOSTCC=${pkgs.buildPackages.stdenv.cc}/bin/cc"
        ]
        ++ (if atf != null then [ "BL31=${atf}/bl31.bin" ] else [ ]);
        preBuild = ''
          echo "=== DEBUG: U-Boot Environment ==="
          echo "CROSS_COMPILE=${pkgs.stdenv.cc.targetPrefix}"
          echo "PWD=$(pwd)"
          echo "================================"
          # setuptools 80.10.1 via PYTHONPATH (pkg_resources, see ubootPython above)
          export PYTHONPATH="${ubootPython}/${ubootPython.sitePackages}:$PYTHONPATH"
        ''
        + (
          if atf != null then
            ''
              cp ${atf}/bl31.bin bl31.bin
              export BL31=$(pwd)/bl31.bin
            ''
          else
            ""
        );
        preConfigure = ''
          # Fix for setuptools license lookup errors in recent U-Boot versions (e.g. v2025.04)
          # Some setup.py files (like pylibfdt) expect these files in the root
          ln -sf Licenses/gpl-2.0.txt GPL
          ln -sf Licenses/bsd-2-clause.txt BSD-2-Clause
        '';
        filesToInstall =
          let
            # Extract family strings safely
            f = if meta ? family && meta.family != null then lib.toLower meta.family else "";
            lf = if meta ? linux_family && meta.linux_family != null then lib.toLower meta.linux_family else "";
            b = if meta ? board && meta.board != null then lib.toLower meta.board else "";

            isSunxi =
              lib.hasInfix "sunxi" f
              || lib.hasInfix "sunxi" lf
              || lib.hasInfix "sun5" f
              || lib.hasInfix "sun5" lf
              || lib.hasInfix "orangepi" b;
            isRockchip =
              lib.hasInfix "rockchip" f
              || lib.hasInfix "rockchip" lf
              || lib.hasInfix "rk3" f
              || lib.hasInfix "rk3" lf;
            isStarfive =
              lib.hasInfix "starfive" f
              || lib.hasInfix "starfive" lf
              || lib.hasInfix "jh7110" f
              || lib.hasInfix "jh7110" lf;

            base = [
              "u-boot-sunxi-with-spl.bin"
              "u-boot.bin"
              "u-boot.img"
              "u-boot-workaround.bin"
            ];
            rockchip = [
              "u-boot.itb"
              "idbloader.img"
            ];
            starfive = [
              "u-boot-spl.bin.normal.out"
              "u-boot.itb"
            ];
          in
          if isSunxi then
            [
              "u-boot-sunxi-with-spl.bin"
              "u-boot.bin"
              "u-boot.img"
            ]
          else if isRockchip then
            base ++ rockchip
          else if isStarfive then
            starfive ++ [ "u-boot.bin" ]
          else
            # For everything else, try to be safe but include common files
            lib.unique (base ++ rockchip ++ starfive);
      };

  # Helper to build upstream U-Boot from denx.de (without Armbian patches)
  buildUpstreamUBoot =
    {
      defconfig,
      version ? "v2026.07",
    }:
    let
      src = pkgs.fetchgit {
        url = "https://source.denx.de/u-boot/u-boot.git";
        rev = version;
        sha256 = lib.fakeSha256;
      };
    in
    pkgs.buildUBoot {
      inherit defconfig src version;
      extraPatches = [ ];
      makeFlags = [ "CROSS_COMPILE=${pkgs.stdenv.cc.targetPrefix}" ];
      preConfigure = ''
        ln -sf Licenses/gpl-2.0.txt GPL
        ln -sf Licenses/bsd-2-clause.txt BSD-2-Clause
      '';
    };

  # Helper to build firmware
  buildFirmware = args: (import ./firmware.nix { inherit pkgs; }).build args;
}
