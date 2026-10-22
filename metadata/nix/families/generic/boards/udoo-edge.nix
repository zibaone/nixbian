{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "udoo";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:linux-6.15.y";
    exact_version = "6.15.11";
    hash = "sha256-grFML/4DY1toV2lNLjTp23Mn1COoT3Qtl9nO3Aw8llo=";
    major_minor = "6.15";
    nvfetcher_key = "kernel-generic-branch-linux-6-15-y";
    patch_dir = "archive/\${LINUXFAMILY}-6.15";
  };
  kernel_params = null;
  uboot = {
    config = "udoo_defconfig";
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
    target_map = ";;SPL:SPL.sdhc u-boot.img:u-boot.img.sdhc";
  };
}
