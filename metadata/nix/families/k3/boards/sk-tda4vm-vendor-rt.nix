{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-rt" {
  board = "sk-tda4vm";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "j721e_evm_a72_defconfig";
  };
}
