{ platforms, lib }:
lib.recursiveUpdate platforms."filogic-current" {
  board = "bananapir4";
  dtb = null;
  family = "filogic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
