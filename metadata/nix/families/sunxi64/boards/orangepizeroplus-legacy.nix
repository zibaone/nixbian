{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "orangepizeroplus";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_zero_plus_defconfig";
  };
}
