{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "nanopiduo";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_duo_defconfig";
  };
}
