{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "bananapim4berry";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
