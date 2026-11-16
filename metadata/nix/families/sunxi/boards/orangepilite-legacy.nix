{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "orangepilite";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_lite_defconfig";
  };
}
