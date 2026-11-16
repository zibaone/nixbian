{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "mba8mpxl-ras314";
  dtb = "freescale/imx8mp-tqma8mpql-mba8mp-ras314.dtb";
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "tqma8mpxl_multi_mba8mp_ras314_defconfig";
  };
}
