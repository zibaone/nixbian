{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "bananapir2";
  dtb = "mediatek/mt7623n-bananapi-bpi-r2";
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
