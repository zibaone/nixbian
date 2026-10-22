{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "armsom-cm5-io";
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
