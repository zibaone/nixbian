{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-edge" {
  board = "bananapif3";
  dtb = "spacemit/k1-bananapi-f3.dtb";
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
