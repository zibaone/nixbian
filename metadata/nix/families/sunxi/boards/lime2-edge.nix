{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "lime2";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "A20-OLinuXino-Lime2-eMMC_defconfig";
  };
}
