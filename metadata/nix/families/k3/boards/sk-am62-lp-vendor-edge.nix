{ platforms, lib }: lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am62-lp";
  dtb = "ti/k3-am62-lp-sk.dts";
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
