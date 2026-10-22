{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "h96-tvbox-3566";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr h96max-v56_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr h96max-v56_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2026.04";
    config = "h96max-v56_defconfig";
    nvfetcher_key = "uboot-tag-v2026-04";
    patch_dir = "v2026.04/board_\${BOARD}";
    source_hash = "sha256-rRw3rtZYVmXYy22QJZY+wWymgxItzRi3axnrNt29ga4=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk35/rk3568_bl31_v1.44.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3568_ddr_1560MHz_v1.21.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
