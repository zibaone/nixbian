{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "orangepipc2";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_pc2_defconfig";
  };
}
