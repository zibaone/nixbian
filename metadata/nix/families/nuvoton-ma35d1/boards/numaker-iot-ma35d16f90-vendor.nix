{ platforms, lib }:
lib.recursiveUpdate platforms."nuvoton-ma35d1-vendor" {
  board = "numaker-iot-ma35d16f90";
  dtb = null;
  family = "nuvoton-ma35d1";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
