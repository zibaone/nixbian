{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am62b";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "am62x_evm_a53_defconfig";
  };
}
