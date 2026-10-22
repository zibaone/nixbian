{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "pinecube";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "pinecube_defconfig";
  };
}
