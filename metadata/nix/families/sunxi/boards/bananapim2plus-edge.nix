{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "bananapim2plus";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "bananapi_m2_plus_h3_defconfig";
  };
}
