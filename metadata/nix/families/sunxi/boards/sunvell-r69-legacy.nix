{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "sunvell-r69";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "sunvell_r69_defconfig";
  };
}
