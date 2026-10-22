{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "mba8mpxl";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
