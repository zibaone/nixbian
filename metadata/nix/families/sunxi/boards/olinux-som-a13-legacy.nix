{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "olinux-som-a13";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "A13-OLinuXino_defconfig";
  };
}
