{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "helios64";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr helios64-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr helios64-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2026.04";
    config = "helios64-rk3399_defconfig";
    nvfetcher_key = "uboot-tag-v2026-04";
    patch_dir = "v2026.04/board_helios64";
    patches = [
      "patches/uboot/v2026.04/board_helios64/1000-exception-include-string.patch"
      "patches/uboot/v2026.04/board_helios64/1001-helios64-enable-target.patch"
      "patches/uboot/v2026.04/board_helios64/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2026.04/board_helios64/general-fix-btrfs-zstd-decompression.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-rRw3rtZYVmXYy22QJZY+wWymgxItzRi3axnrNt29ga4=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.22.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3399_ddr_933MHz_v1.25.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
