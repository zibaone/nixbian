{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am62-lp";
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
