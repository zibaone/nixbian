{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "pcduino3";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Linksprite_pcDuino3_defconfig";
  };
}
