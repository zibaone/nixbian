{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "tritium-h5";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "libretech_all_h3_cc_h5_defconfig";
  };
}
