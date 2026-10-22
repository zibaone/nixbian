{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "beelinkx2";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "beelink_x2_defconfig";
  };
}
