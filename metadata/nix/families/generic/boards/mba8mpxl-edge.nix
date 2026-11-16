{ platforms, lib }: lib.recursiveUpdate platforms."generic-edge" {
  board = "mba8mpxl";
  dtb = "freescale/imx8mp-tqma8mpql-mba8mpxl.dtb";
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
