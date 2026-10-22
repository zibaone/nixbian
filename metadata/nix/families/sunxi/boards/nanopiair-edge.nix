{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "nanopiair";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_neo_air_defconfig";
  };
}
