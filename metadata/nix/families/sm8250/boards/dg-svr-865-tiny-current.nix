{ platforms, lib }:
lib.recursiveUpdate platforms."sm8250-current" {
  board = "dg-svr-865-tiny";
  dtb = null;
  family = "sm8250";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
