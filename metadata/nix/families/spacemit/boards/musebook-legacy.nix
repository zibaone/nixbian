{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-legacy" {
  board = "musebook";
  dtb = "spacemit/k1-musebook.dtb";
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
