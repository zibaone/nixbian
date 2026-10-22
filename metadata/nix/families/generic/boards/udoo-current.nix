{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "udoo";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2022.07";
    config = "udoo_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "legacy/u-boot-imx6";
    patches = [
      "patches/uboot/legacy/u-boot-imx6/board_cubox-i/change_logo_to_armbian.patch"
      "patches/uboot/legacy/u-boot-imx6/board_udoo/udoo-adjust-env.patch"
      "patches/uboot/legacy/u-boot-imx6/board_wandboard/0001-wandboard-uEnv.txt-bootz-n-fixes.patch"
      "patches/uboot/legacy/u-boot-imx6/libfdt_fix.patch"
      "patches/uboot/legacy/u-boot-imx6/target_sata/enable_sata.patch"
      "patches/uboot/legacy/u-boot-imx6/target_sdhc/enable_sdhc.patch"
      "patches/uboot/legacy/u-boot-imx6/target_spi/enable_spi.patch"
      "patches/uboot/legacy/u-boot-imx6/use-armv7a-for-modern-toolchain.patch"
    ];
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
    target_map = ";;SPL:SPL.sdhc u-boot.img:u-boot.img.sdhc";
  };
}
