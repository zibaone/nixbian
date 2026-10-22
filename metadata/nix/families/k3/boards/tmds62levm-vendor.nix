{ platforms, lib }:
lib.recursiveUpdate platforms."k3-vendor" {
  board = "tmds62levm";
  dtb = null;
  family = "k3";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_platform = "k3low";
    atf_target_map = "PLAT=k3low TARGET_BOARD=am62lx SPD=opteed \${ATF_ARGS} all;;build/k3low/am62lx/release/bl31.bin:bl31.bin build/k3low/am62lx/release/bl1.bin:bl1.bin";
    config = "am62lx_evm_defconfig";
    target_map = "BL31=bl31.bin BL1=bl1.bin TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
  };
}
