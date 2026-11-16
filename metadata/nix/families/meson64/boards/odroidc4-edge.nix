{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "odroidc4";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "odroid-c4_defconfig";
  };
}
