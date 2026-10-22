{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "bananapir2";
  dtb = null;
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
