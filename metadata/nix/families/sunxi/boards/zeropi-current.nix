{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "zeropi";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "zeropi_defconfig";
  };
}
