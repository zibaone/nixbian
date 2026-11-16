{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am64b";
  dtb = "ti/k3-am642-sk.dts";
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "am64x_evm_a53_defconfig";
  };
}
