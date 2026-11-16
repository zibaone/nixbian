{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "orangepipc";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_pc_defconfig";
  };
}
