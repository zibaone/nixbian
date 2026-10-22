{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor-edge" {
  board = "sk-am62-sip";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed BL32_BASE=0x80080000 PRELOADED_BL33_BASE=0x82000000 all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
    config = "am6254atl_evm_a53_defconfig";
  };
}
