{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-current" {
  board = "orangepizero2w";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_zero2w_defconfig";
  };
}
