{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "lime-a33";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "A33-OLinuXino_defconfig";
  };
}
