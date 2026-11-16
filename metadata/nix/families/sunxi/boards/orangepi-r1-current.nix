{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "orangepi-r1";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_r1_defconfig";
  };
}
