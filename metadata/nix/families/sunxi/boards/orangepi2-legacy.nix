{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "orangepi2";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_2_defconfig";
  };
}
