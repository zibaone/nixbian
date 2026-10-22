{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "bananapim1plus";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "bananapi_m1_plus_defconfig";
  };
}
