{ platforms, lib }:
lib.recursiveUpdate platforms."rk35xx-vendor" {
  board = "armsom-aim7-io";
  dtb = null;
  family = "rk35xx";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
