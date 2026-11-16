{ platforms, lib }:
lib.recursiveUpdate platforms."spacemit-legacy" {
  board = "orangepirv2";
  dtb = "spacemit/k1-orangepi-rv2.dtb";
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
