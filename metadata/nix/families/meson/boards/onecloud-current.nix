{ platforms, lib }:
lib.recursiveUpdate platforms."meson-current" {
  board = "onecloud";
  dtb = null;
  family = "meson";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
