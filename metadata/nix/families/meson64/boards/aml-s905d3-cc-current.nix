{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "aml-s905d3-cc";
  dtb = "amlogic/meson-sm1-s905d3-libretech-cc.dtb";
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "libre_computer_aml_s905d3_cc_defconfig";
  };
}
