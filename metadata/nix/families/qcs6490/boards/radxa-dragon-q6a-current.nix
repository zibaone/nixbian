{ platforms, lib }:
lib.recursiveUpdate platforms."qcs6490-current" {
  board = "radxa-dragon-q6a";
  dtb = null;
  family = "qcs6490";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
