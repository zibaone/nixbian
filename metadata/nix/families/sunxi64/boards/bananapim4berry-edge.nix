{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "bananapim4berry";
  dtb = "sun50i-h618-bananapi-m4-berry.dtb";
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
