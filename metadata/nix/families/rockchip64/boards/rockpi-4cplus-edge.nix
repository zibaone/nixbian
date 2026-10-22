{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "rockpi-4cplus";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr rock-4c-plus-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr rock-4c-plus-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "rock-4c-plus-rk3399_defconfig";
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
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3399_bl31_v1.36.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3399_ddr_933MHz_v1.30.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
