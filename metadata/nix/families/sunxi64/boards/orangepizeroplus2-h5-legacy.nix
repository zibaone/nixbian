{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "orangepizeroplus2-h5";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_zero_plus2_defconfig";
  };
}
