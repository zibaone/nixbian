{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-legacy" {
  board = "musebook";
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
