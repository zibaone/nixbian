{ platforms, lib }:
lib.recursiveUpdate platforms."bcm2711-current" {
  board = "rpi4b";
  dtb = null;
  family = "bcm2711";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
