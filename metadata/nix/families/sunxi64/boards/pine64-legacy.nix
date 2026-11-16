{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "pine64";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "pine64_plus_defconfig";
  };
}
