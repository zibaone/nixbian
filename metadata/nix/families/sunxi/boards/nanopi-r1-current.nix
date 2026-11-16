{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "nanopi-r1";
  dtb = "sun8i-h3-nanopi-r1.dtb";
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_r1_defconfig";
  };
}
