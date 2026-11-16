{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "nanopineo";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_neo_defconfig";
  };
}
