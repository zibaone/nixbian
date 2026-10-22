{ platforms, lib }:
lib.recursiveUpdate platforms."sm8550-current" {
  board = "ayn-odin2";
  dtb = null;
  family = "sm8550";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
