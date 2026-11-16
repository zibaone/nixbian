{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "bananapipro";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Bananapro_defconfig";
  };
}
