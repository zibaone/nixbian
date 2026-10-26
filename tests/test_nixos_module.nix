let
  self = builtins.getFlake ("path:" + (toString ../.));
  pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;

  # Evaluate a mock NixOS configuration utilizing our flake's module
  nixos = self.inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      self.nixosModules.default
      {
        hardware.nixbian.enable = true;
        hardware.nixbian.board = "orangepizero3";
        hardware.nixbian.kernelVendor = "current";

        # Test case: Exclude any patch that matches "logo"
        hardware.nixbian.excludePatchPatterns = [ ".*logo.*" ];

        # Test case: Add a mock patch
        hardware.nixbian.extraPatches = [ (builtins.toFile "test.patch" "diff -u a b") ];

        # Test case: Custom Device Tree Overlays
        hardware.nixbian.overlays = [ (builtins.toFile "test.dts" "/dts-v1/; / { };") ];

        # Test case: Enable security hardening
        hardware.nixbian.security.harden = true;

        # Test case: extraConfig merging (P1.2/P1.3). Two same-priority
        # definitions must merge, the `mkAfter` one landing last: with
        # `types.str` this is a conflicting-definition error.
        hardware.nixbian.extraConfig = "CONFIG_TEST_A=y";

        # Test case: Declarative GPIO, I2C, SPI
        hardware.nixbian.i2c.buses = [
          0
          {
            bus = 1;
            clockFrequency = 400000;
          }
        ];
        hardware.nixbian.spi.buses = [ 0 ];
        hardware.nixbian.gpio.pins = {
          PA10 = {
            direction = "out";
            initialValue = 1;
            bias = "pullup";
          };
          PC4 = {
            direction = "in";
            bias = "pulldown";
          };
        };

        # Minimal NixOS options to pass evaluation validation
        fileSystems."/" = {
          device = "/dev/sda1";
          fsType = "ext4";
        };
        boot.loader.grub.enable = false;
      }
      # Second definition of the same option, ordered last (P1.3).
      { hardware.nixbian.extraConfig = pkgs.lib.mkAfter "CONFIG_TEST_B=y"; }
    ];
  };

  # 1. Verification of Patches
  evaluatedPatches = nixos.config.boot.kernelPackages.kernel.kernelPatches;
  hasTestPatch = pkgs.lib.any (p: pkgs.lib.hasSuffix "test.patch" p.name) evaluatedPatches;
  hasLogoPatch = pkgs.lib.any (p: pkgs.lib.match ".*logo.*" p.name != null) evaluatedPatches;

  # 2. Verification of Overlays
  evaluatedOverlays = nixos.config.hardware.deviceTree.overlays;
  hasOverlay = pkgs.lib.any (o: pkgs.lib.hasSuffix "test.dts" o.dtsFile) evaluatedOverlays;

  # 3. Verification of Filesystem Support (f2fs/btrfs default)
  hasF2FS = nixos.config.boot.supportedFilesystems ? f2fs;
  hasBtrfs = nixos.config.boot.supportedFilesystems ? btrfs;

  # 4. Verification of Wear Mitigation
  hasTmpfs = nixos.config.boot.tmp.useTmpfs;
  hasVolatileJournal = nixos.config.services.journald.extraConfig == "Storage=volatile";
  hasZram = nixos.config.zramSwap.enable;

  # 5. Verification of Hardening
  hasHardenedSysctl = nixos.config.boot.kernel.sysctl."net.ipv4.tcp_syncookies" == 1;

  # 6. Verification of Declarative Buses
  hasI2cOverlay = pkgs.lib.any (o: o.name == "nixbian-i2c") evaluatedOverlays;
  hasSpiOverlay = pkgs.lib.any (o: o.name == "nixbian-spi") evaluatedOverlays;

  # 7. Verification of GPIO Services
  hasPA10Service = nixos.config.systemd.services ? nixbian-gpio-PA10;
  hasPC4Service = nixos.config.systemd.services ? nixbian-gpio-PC4;

  # 8. L5 — system.modulesTree really is the filtered tree, not the full aggregate.
  modulesTree = nixos.config.system.modulesTree;
  fullModulesTree = pkgs.aggregateModules [ nixos.config.boot.kernelPackages.kernel.modules ];
  hasFilteredModulesTree = modulesTree.drvPath != fullModulesTree.drvPath;

  # 9. P1.2 — extraConfig is a merge type: a `mkDefault` line must not be
  # dropped by a normal-priority definition, and the normal one comes last.
  extraConfig = nixos.config.hardware.nixbian.extraConfig;
  hasBothExtraConfig =
    pkgs.lib.hasInfix "CONFIG_TEST_A=y" extraConfig
    && pkgs.lib.hasInfix "CONFIG_TEST_B=y" extraConfig;
  extraConfigBLast = pkgs.lib.hasSuffix "CONFIG_TEST_B=y" extraConfig;

in
if !hasTestPatch then
  throw "Integration Test Failed: missing test.patch!"
else if hasLogoPatch then
  throw "Integration Test Failed: logo patch was not excluded!"
else if !hasOverlay then
  throw "Integration Test Failed: custom overlays not compiled or mapped!"
else if !hasF2FS || !hasBtrfs then
  throw "Integration Test Failed: default filesystems (f2fs, btrfs) not supported!"
else if !hasTmpfs || !hasVolatileJournal || !hasZram then
  throw "Integration Test Failed: wear mitigation options are not set correctly!"
else if !hasHardenedSysctl then
  throw "Integration Test Failed: security hardening sysctls not set!"
else if !hasI2cOverlay || !hasSpiOverlay then
  throw "Integration Test Failed: missing declarative I2C/SPI overlays!"
else if !hasPA10Service || !hasPC4Service then
  throw "Integration Test Failed: missing GPIO systemd services!"
else if !hasFilteredModulesTree then
  throw "Integration Test Failed: L5 system.modulesTree does not point to the filtered tree!"
else if !hasBothExtraConfig then
  throw "Integration Test Failed: extraConfig dropped one of two definitions (types.str, not a merge type)!"
else if !extraConfigBLast then
  throw "Integration Test Failed: extraConfig does not end with the normal-priority definition!"
else
  "Integration Test Passed: all patch, DTB overlay, wear mitigation, hardening, filesystem, bus, GPIO and extraConfig merge engines are fully functional!\n"
