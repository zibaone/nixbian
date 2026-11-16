{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "orangepizeroplus2-h3";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_zero_plus2_h3_defconfig";
  };
}
