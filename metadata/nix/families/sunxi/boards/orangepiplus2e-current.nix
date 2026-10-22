{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "orangepiplus2e";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_plus2e_defconfig";
  };
}
