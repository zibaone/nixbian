{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "tritium-h3";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "libretech_all_h3_cc_h3_defconfig";
  };
}
