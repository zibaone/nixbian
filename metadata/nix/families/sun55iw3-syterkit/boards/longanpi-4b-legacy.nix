{ platforms, lib }:
lib.recursiveUpdate platforms."sun55iw3-syterkit-legacy" {
  board = "longanpi-4b";
  dtb = "allwinner/sun55i-t527-longanpi-4b-pcie.dtb";
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
