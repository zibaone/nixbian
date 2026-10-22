{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-edge" {
  board = "bananapif3";
  dtb = null;
  family = "spacemit";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
