{ self, ... }:
{
  perSystem =
    {
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      # Define where to look for local metadata (can be overridden)
      localMetadata = self + "/metadata";

      versionedSources = lib.listToAttrs (
        map (v: {
          name = "armbian-source-${v}";
          value = self.lib.fetchArmbian pkgs v;
        }) (lib.attrNames (builtins.fromJSON (builtins.readFile (self + "/versions.json"))))
      );

      # Load data for the current repo
      data = self.lib.loadMetadata pkgs localMetadata;

      # Build packages for each family
      familyPackages = lib.mapAttrs (
        familyName: familyData:
        let
          # Extract the architecture from the first platform in the family
          platformsList = lib.attrValues familyData.platforms;
          arch = if platformsList == [ ] then "arm64" else (lib.head platformsList).arch or "arm64";

          # Determine target system string in Nixpkgs format
          targetSystem =
            if arch == "arm64" then
              "aarch64-linux"
            else if arch == "riscv64" then
              "riscv64-linux"
            else if arch == "armhf" then
              "armv7l-linux"
            else if arch == "loong64" then
              "loongarch64-linux"
            else if arch == "amd64" then
              "x86_64-linux"
            else
              "";

          # Choose the correct package set (native if host matches target, else cross)
          crossPkgs =
            if targetSystem == "" || pkgs.stdenv.hostPlatform.system == targetSystem then
              pkgs
            else if arch == "arm64" then
              pkgs.pkgsCross.aarch64-multiplatform
            else if arch == "riscv64" then
              pkgs.pkgsCross.riscv64
            else if arch == "armhf" then
              pkgs.pkgsCross.armv7l-hf-multiplatform
            else if arch == "loong64" then
              pkgs.pkgsCross.loongarch64-linux
            else
              pkgs;
          helpers = (import (self + "/metadata/nix/library.nix")) { pkgs = crossPkgs; };
          familyPkgFile = self + "/metadata/nix/families/${familyName}/package.nix";
          familyPkgFunc = if builtins.pathExists familyPkgFile then import familyPkgFile else null;
          # Load sources from nvfetcher
          sources = pkgs.callPackage (self + "/metadata/sources/generated.nix") { };
        in
        if familyPkgFunc != null then
          familyPkgFunc {
            pkgs = crossPkgs;
            inherit helpers sources;
          }
        else
          { }
      ) data.families;

      # Expose all boards as individual packages
      # We take the firmware package as the primary target for a board
      allBoards = lib.foldl' (acc: familyPkg: acc // (familyPkg.firmwares or { })) { } (
        lib.attrValues familyPackages
      );

      # Expose all kernels and U-Boots with prefixes for direct flat build access
      # kernels -> kernel-<name> (armbian tier, default); defconfigKernels -> kernel-<name>-defconfig.
      # Tolerant access (or { }): defconfigKernels does not exist before metadata/ is regenerated.
      allKernels = lib.filterAttrs (n: v: v != null) (
        lib.foldl' (
          acc: familyPkg:
          acc
          // (lib.mapAttrs' (name: value: {
            name = "kernel-${name}";
            inherit value;
          }) (familyPkg.kernels or { }))
          // (lib.mapAttrs' (name: value: {
            name = "kernel-${name}-defconfig";
            inherit value;
          }) (familyPkg.defconfigKernels or { }))
        ) { } (lib.attrValues familyPackages)
      );

      # L5 — per-board filtered modules (cheap derivation on the shared tree,
      # no kernel rebuild). The host allowlist goes through kernelModulesFor.
      allKernelModules = lib.filterAttrs (n: v: v != null) (
        lib.foldl' (
          acc: familyPkg:
          acc
          // (lib.mapAttrs' (name: value: {
            name = "kernelModules-${name}";
            inherit value;
          }) (familyPkg.kernelModules or { }))
        ) { } (lib.attrValues familyPackages)
      );

      allUBoots = lib.filterAttrs (n: v: v != null) (
        lib.foldl' (
          acc: familyPkg:
          acc
          // (lib.mapAttrs' (name: value: {
            name = "uboot-${name}";
            inherit value;
          }) (familyPkg.uBoots or { }))
        ) { } (lib.attrValues familyPackages)
      );

      # Map each board key to its corresponding platform kernel package (e.g. kernel-orangepizero3-current)
      # kernel-<boardKey> = armbian tier (default); kernel-<boardKey>-defconfig = defconfig tier.
      # Tolerant access (or { }): defconfigKernels does not exist before metadata/ is regenerated.
      boardKernels = lib.listToAttrs (
        lib.filter (x: x.value != null) (
          lib.concatLists (
            lib.mapAttrsToList (
              boardName: boardPkg:
              let
                boardMeta = data.platforms.${boardName} or { };
                familyName = boardMeta.family or "";
                branchName = boardMeta.branch or "";
                familyPkg = familyPackages.${familyName} or { };
                kernelKey = "${familyName}-${branchName}";
                kernelPkg = (familyPkg.kernels or { }).${kernelKey} or null;
                defconfigKernelPkg = (familyPkg.defconfigKernels or { }).${kernelKey} or null;
              in
              [
                {
                  name = "kernel-${boardName}";
                  value = kernelPkg;
                }
                {
                  name = "kernel-${boardName}-defconfig";
                  value = defconfigKernelPkg;
                }
              ]
            ) allBoards
          )
        )
      );

      # Source derivations (fetchgit) — buildable independently of the full kernel/U-Boot
      allKernelSrcs = lib.filterAttrs (n: v: v != null) (
        lib.foldl' (
          acc: familyPkg:
          acc
          // (lib.mapAttrs' (name: value: {
            name = "kernel-${name}-src";
            inherit value;
          }) (familyPkg.kernelSrcs or { }))
        ) { } (lib.attrValues familyPackages)
      );

      allUBootSrcs = lib.filterAttrs (n: v: v != null) (
        lib.foldl' (
          acc: familyPkg:
          acc
          // (lib.mapAttrs' (name: value: {
            name = "uboot-${name}-src";
            inherit value;
          }) (familyPkg.ubootSrcs or { }))
        ) { } (lib.attrValues familyPackages)
      );

    in
    {
      packages = {
        default = pkgs.python3Packages.buildPythonApplication {
          pname = "nixbian";
          # Single source of the version: pyproject.toml (PEP 621).
          version = (builtins.fromTOML (builtins.readFile (self + "/pyproject.toml"))).project.version;
          src = self;
          pyproject = true;
          propagatedBuildInputs = [
            pkgs.python3Packages.pyyaml
            pkgs.python3Packages.requests
            pkgs.python3Packages.setuptools
            pkgs.python3Packages.wheel
            pkgs.python3Packages.toml
          ];
        };

        # Main metadata package
        metadata = pkgs.runCommand "nixbian-local-metadata" { } ''
          mkdir -p $out
          cp -r ${localMetadata}/* $out/
        '';

        # Global index for discovery
        boardsIndex = pkgs.writeText "boards.json" (builtins.toJSON data.boardsIndex);
      }
      // versionedSources
      // allBoards
      // allKernels
      // allKernelModules
      // allUBoots
      // boardKernels
      // allKernelSrcs
      // allUBootSrcs;

      # Hierarchical exposure of all boards (backward compatibility)
      legacyPackages = familyPackages // {
        metadata = data.families;
        platforms = allBoards;
        boards = lib.mapAttrs (fName: fPkg: fPkg.firmwares or { }) familyPackages;
      };
    };
}
