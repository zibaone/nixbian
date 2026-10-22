{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor" {
  board = "sk-am68";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "PLAT=k3 TARGET_BOARD=generic SPD=opteed K3_USART=0x8 all;;build/k3/generic/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
    config = "j721s2_evm_a72_defconfig";
  };
}
