{ platforms, lib }:
lib.recursiveUpdate platforms."sm8250-current" {
  board = "retroidpocket-rp5";
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
