{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "radxa-rock-4d";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr rock-4d-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr rock-4d-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "rock-4d-rk3576_defconfig";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.22.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3576_ddr_lp4_2112MHz_lp5_2736MHz_v1.09.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
