{ platforms, lib }: lib.recursiveUpdate platforms."k3-vendor" {
  board = "beaglebone-ai64";
  dtb = "ti/k3-j721e-beagleboneai64.dts";
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
