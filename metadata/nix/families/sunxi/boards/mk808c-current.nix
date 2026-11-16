{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "mk808c";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "MK808C_defconfig";
  };
}
