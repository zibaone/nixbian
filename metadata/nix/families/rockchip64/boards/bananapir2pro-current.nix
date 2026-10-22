{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "bananapir2pro";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr bpi-r2-pro-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr bpi-r2-pro-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "bpi-r2-pro-rk3568_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "v2024.01";
    patches = [
      "patches/uboot/v2024.01/board_lepotato/le-potato-general-vendor.patch"
      "patches/uboot/v2024.01/board_nanopik2-s905/add-emmc-support-for-nanopi-k2.patch"
      "patches/uboot/v2024.01/board_orangepi5/0010-Fix-SPI-Boot.patch"
      "patches/uboot/v2024.01/general-btrfs-fix-out-of-bounds-write.patch"
      "patches/uboot/v2024.01/general-btrfs-fix-reading-when-length-specified.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
  };
}
