{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "orangepiplus";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_plus_defconfig";
  };
}
