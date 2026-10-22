{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "tinkerboard-2";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr tinker-2-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr tinker-2-rk3399_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2025.04";
    config = "tinker-2-rk3399_defconfig";
    nvfetcher_key = "uboot-tag-v2025-04";
    patch_dir = "legacy/u-boot-tinkerboard2";
    patches = [ "patches/uboot/legacy/u-boot-tinkerboard2/add-board-tinker-board-2.patch" ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-P9y1I1STiL8rDdj2OHfmP04468hLWwZM3E2v1Y/cLAM=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.22.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3399_ddr_800MHz_v1.27.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
