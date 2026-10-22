{ platforms, lib }:
lib.recursiveUpdate platforms."k3-edge" {
  board = "beaglebone-ai64";
  dtb = null;
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
