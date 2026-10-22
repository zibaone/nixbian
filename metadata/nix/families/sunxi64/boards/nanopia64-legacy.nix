{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "nanopia64";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_a64_defconfig";
  };
}
