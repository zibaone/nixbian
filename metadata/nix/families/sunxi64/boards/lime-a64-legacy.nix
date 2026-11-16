{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "lime-a64";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "a64-olinuxino_defconfig";
  };
}
