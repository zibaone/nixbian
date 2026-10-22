{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "pocketchip-sd";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "CHIP_defconfig";
  };
}
