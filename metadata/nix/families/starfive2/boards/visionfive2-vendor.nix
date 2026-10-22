{ platforms, lib }:
lib.recursiveUpdate platforms."starfive2-vendor" {
  board = "visionfive2";
  dtb = null;
  family = "starfive2";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
