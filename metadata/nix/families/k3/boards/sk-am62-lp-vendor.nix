{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor" {
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
    atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed \${ATF_ARGS} all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
    config = "am62x_lpsk_a53_defconfig";
  };
}
