{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "bananapi";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
