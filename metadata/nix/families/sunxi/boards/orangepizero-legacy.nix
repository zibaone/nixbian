{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "orangepizero";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_zero_defconfig";
  };
}
