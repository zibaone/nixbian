{ platforms, lib }:
lib.recursiveUpdate platforms."k3-beagle-edge" {
  board = "beagley-ai";
  dtb = null;
  family = "k3-beagle";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
