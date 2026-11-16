{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "bananapim2zero";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "bananapi_m2_zero_defconfig";
  };
}
