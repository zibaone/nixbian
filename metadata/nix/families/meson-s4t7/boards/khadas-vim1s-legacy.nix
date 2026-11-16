{ platforms, lib }:
lib.recursiveUpdate platforms."meson-s4t7-legacy" {
  board = "khadas-vim1s";
  dtb = null;
  family = "meson-s4t7";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
