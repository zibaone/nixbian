{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "olimex-teres-a64";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "teres_i_defconfig";
  };
}
