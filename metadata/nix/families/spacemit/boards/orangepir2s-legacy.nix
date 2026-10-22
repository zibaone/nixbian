{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-legacy" {
  board = "orangepir2s";
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
