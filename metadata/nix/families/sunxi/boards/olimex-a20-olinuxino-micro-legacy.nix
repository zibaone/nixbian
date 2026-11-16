{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "olimex-a20-olinuxino-micro";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "A20-OLinuXino_MICRO-eMMC_defconfig";
  };
}
