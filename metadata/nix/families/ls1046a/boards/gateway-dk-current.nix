{ platforms, lib }:
lib.recursiveUpdate platforms."ls1046a-current" {
  board = "gateway-dk";
  dtb = null;
  family = "ls1046a";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
