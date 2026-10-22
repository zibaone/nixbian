{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-rt" {
  board = "sk-am69";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "PLAT=k3 TARGET_BOARD=j784s4 SPD=opteed K3_USART=0x8 all;;build/k3/j784s4/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
    config = "am69_sk_a72_defconfig";
  };
}
