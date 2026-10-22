{ platforms, lib }:
lib.recursiveUpdate platforms."rk35xx-vendor" {
  board = "turing-rk1";
  dtb = null;
  family = "rk35xx";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr turing-rk1-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr turing-rk1-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "turing-rk1-rk3588_defconfig";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.22.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_uart9_115200_v1.16.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
