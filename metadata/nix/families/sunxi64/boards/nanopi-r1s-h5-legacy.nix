{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "nanopi-r1s-h5";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_r1s_h5_defconfig";
  };
}
