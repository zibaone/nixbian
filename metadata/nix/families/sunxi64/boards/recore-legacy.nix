{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "recore";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "recore_defconfig";
    target_map = "SCP=/dev/null;;u-boot-sunxi-with-spl.bin";
  };
}
