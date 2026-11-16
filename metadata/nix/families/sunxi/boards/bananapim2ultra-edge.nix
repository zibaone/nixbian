{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "bananapim2ultra";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Bananapi_M2_Ultra_defconfig";
  };
}
