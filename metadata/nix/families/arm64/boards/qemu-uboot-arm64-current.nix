{ platforms, lib }:
lib.recursiveUpdate platforms."arm64-current" {
  board = "qemu-uboot-arm64";
  dtb = null;
  family = "arm64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "qemu_arm64_defconfig";
    target_map = "all;;u-boot.bin";
  };
}
