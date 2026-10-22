let
  self = builtins.getFlake ("path:" + (toString ../.));
  pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
  lib = pkgs.lib;

  # 1. Verify that all devShells are defined and not null
  devShells = self.devShells.x86_64-linux;

  # Check that default and board devShells exist
  hasDefaultShell = devShells ? default;

  # Find some specific board devShells to verify they are present
  hasOpiZero3KernelDev = devShells ? "kernel-dev-orangepizero3-current";
  hasOpiZero3UbootDev = devShells ? "uboot-dev-orangepizero3-current";

  # 2. Verify devShell shellHook commands exist
  opiZero3KernelDevHook = devShells."kernel-dev-orangepizero3-current".shellHook or "";
  hasUnpackKernelCmd = lib.hasInfix "unpack-kernel" opiZero3KernelDevHook;

  # 3. Verify that the generic family packages (heterogeneous architectures) evaluate cleanly
  genericCurrentKernel = self.packages.x86_64-linux.kernel-generic-current;
  genericVendorKernel = self.packages.x86_64-linux.kernel-generic-vendor;

  # 3bis. L5 — the board-filtered derivation exists and stays cheap (not a
  # kernel rebuild: its drvPath does not depend on the compiled kernel config).
  hasOpiZero3Modules = self.packages.x86_64-linux ? "kernelModules-orangepizero3-edge";
  modulesFilter =
    self.legacyPackages.x86_64-linux.sunxi64.kernelModulesFor.orangepizero3-edge or null;

  # 3ter. Kernel provenance (passthru, no impact on the drv/cache).
  opiZero3Kernel = self.packages.x86_64-linux.kernel-orangepizero3-edge;
  kernelPassthruOk =
    opiZero3Kernel.passthru.platformKey == "sunxi64-edge"
    && opiZero3Kernel.passthru.linuxFamily == "sunxi64"
    && opiZero3Kernel.passthru.branch == "edge"
    && opiZero3Kernel.passthru.armbianVersion == "v26.5.1";

  # Verify target systems are mapped correctly based on arch
  isGenericCurrentArmhf = genericCurrentKernel.stdenv.hostPlatform.system == "armv7l-linux";
  isGenericVendorArm64 = genericVendorKernel.stdenv.hostPlatform.system == "aarch64-linux";
in
if !hasDefaultShell then
  throw "Flake Test Failed: default devShell is missing!"
else if !hasOpiZero3KernelDev || !hasOpiZero3UbootDev then
  throw "Flake Test Failed: board-specific devShells for orangepizero3 are missing!"
else if !hasUnpackKernelCmd then
  throw "Flake Test Failed: kernel-dev shellHook is missing the unpack-kernel command!"
else if !hasOpiZero3Modules then
  throw "Flake Test Failed: L5 kernelModules-orangepizero3-edge is missing!"
else if modulesFilter == null then
  throw "Flake Test Failed: L5 kernelModulesFor.orangepizero3-edge is missing!"
else if !kernelPassthruOk then
  throw "Flake Test Failed: kernel passthru provenance (platformKey/linuxFamily/branch/armbianVersion) is wrong!"
else if !isGenericCurrentArmhf then
  throw "Flake Test Failed: generic-current (armhf) kernel stdenv hostPlatform system is not armv7l-linux!"
else if !isGenericVendorArm64 then
  throw "Flake Test Failed: generic-vendor (arm64) kernel stdenv hostPlatform system is not aarch64-linux!"
else
  "Flake Test Passed: all devShells and heterogeneous generic packages evaluate and target architectures correctly!\n"
