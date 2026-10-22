{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "sakurapi-rk3308b";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr sakurapi_rk3308b_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr sakurapi_rk3308b_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "sakurapi_rk3308b_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "v2025.04";
    patches = [
      "patches/uboot/v2025.04/board_cherryba-m1/add_and_fix_cherryba-m1_uboot.patch"
      "patches/uboot/v2025.04/board_jethubj200/0001-Add-JetHub-D2.patch"
      "patches/uboot/v2025.04/board_jethubj200/0002-add-ssd1306-joystick-and-gpio-expander-support.patch"
      "patches/uboot/v2025.04/board_jethubj200/0003-arm-meson-unify-type-being-used-for-socinfo.patch"
      "patches/uboot/v2025.04/board_jethubj200/0004-arm-meson-sm-get-rid-of-SM_CHIP_ID_SIZE.patch"
      "patches/uboot/v2025.04/board_jethubj200/0005-arch-arm-meson-support-Amlogic-chip_id-v1-and-v2.patch"
      "patches/uboot/v2025.04/board_jethubj200/0006-arm-meson-add-securemonitor-getmax-function.patch"
      "patches/uboot/v2025.04/board_jethubj200/0007-add-missing-u-boot-meson64-patch-for-overlays.patch"
      "patches/uboot/v2025.04/board_khadas-vim3/meson64-boot-usb-nvme-scsi-first.patch"
      "patches/uboot/v2025.04/board_lckfb-taishanpi/0001-configs-add-lckfb-tspi-rk3566-defconfig.patch"
      "patches/uboot/v2025.04/board_orangepi5-max/orangepi-5-max-add-support.patch"
      "patches/uboot/v2025.04/board_orangepi5-max/orangepi-5-max-add-upstream-dts.patch"
      "patches/uboot/v2025.04/board_sakurapi-rk3308b/add-board-sakurapi-rk3308b.patch"
      "patches/uboot/v2025.04/board_station-p2/0001-add-support-for-station-p2.patch"
      "patches/uboot/v2025.04/cmd-fileenv-read-string-from-file-into-env.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.26.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3308_ddr_589MHz_uart2_m1_v1.30.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
