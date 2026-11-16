{ platforms, lib }:
lib.recursiveUpdate platforms."meson-s4t7-legacy" {
  board = "khadas-vim4";
  dtb = null;
  family = "meson-s4t7";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "kvim4_defconfig";
  };
}
