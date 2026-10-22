{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am62p";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "am62px_evm_a53_defconfig";
  };
}
