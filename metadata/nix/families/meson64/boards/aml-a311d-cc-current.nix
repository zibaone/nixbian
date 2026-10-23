{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "aml-a311d-cc";
  dtb = "amlogic/meson-g12b-a311d-libretech-cc.dtb";
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
