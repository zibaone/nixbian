{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "khadas-vim3";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2025.04";
    config = "khadas-vim3_defconfig";
    nvfetcher_key = "uboot-tag-v2025-04";
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
    source_hash = "sha256-P9y1I1STiL8rDdj2OHfmP04468hLWwZM3E2v1Y/cLAM=";
    target_map = "u-boot-dtb.img;;u-boot.bin.sd.bin:u-boot.bin u-boot-dtb.img u-boot.bin:u-boot-spi.bin";
  };
}
