{ platforms, lib }:
lib.recursiveUpdate platforms."sun55iw3-syterkit-legacy" {
  board = "avaota-a1";
  dtb = "allwinner/sun55i-t527-avaota-a1.dtb";
  family = "sun55iw3-syterkit";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
