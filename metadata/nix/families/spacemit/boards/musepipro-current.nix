{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-current" {
  board = "musepipro";
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
