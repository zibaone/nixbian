{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "orangepizero3";
  dtb = "allwinner/sun50i-h618-orangepi-zero3.dtb";
  family = "sunxi64";
  firmware = {
  };
  firmware_include = [
    "sunxi"
    "sunxi64"
    "bt"
  ];
  kernel = {
  };
  kernel_params = "console=ttyS0,115200";
  uboot = {
    config = "orangepi_zero3_defconfig";
    patch_dir = "v2025-sunxi";
    patches = [
      "patches/uboot/v2025-sunxi/0001-sunxi-h616-dram-Rework-size-detection.patch"
      "patches/uboot/v2025-sunxi/0002-sunxi-H616-dram-Improve-address-wrapping-detection.patch"
      "patches/uboot/v2025-sunxi/0003-sunxi-mmc-Improve-reset-procedure.patch"
      "patches/uboot/v2025-sunxi/0004-Add-MACH_SUN8I_A83T-to-can-calibrate.patch"
      "patches/uboot/v2025-sunxi/0005-board-sunxi-The-prefix-is-missing-if-we-use-OF_UPSTREAM.patch"
      "patches/uboot/v2025-sunxi/0006-dts-upstream-arm64-sun50i-h616-sync-with-sunxi-6.12-kernel.patch"
      "patches/uboot/v2025-sunxi/0007-dts-upstream-arm64-Add-sun50i-h618-bananapi-m4-berry.dts.patch"
      "patches/uboot/v2025-sunxi/0008-u-boot-configs-Add-sun50i-h618-bananapi-m4berry-defconfig.patch"
      "patches/uboot/v2025-sunxi/0009-sunxi-h616-dram-support-1.5GB-RAM-size.patch"
    ];
  };
}
