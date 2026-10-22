{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "bigtreetech-cb2";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr bigtreetech-cb2-rk3566_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr bigtreetech-cb2-rk3566_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2024.10";
    config = "bigtreetech-cb2-rk3566_defconfig";
    nvfetcher_key = "uboot-tag-v2024-10";
    patch_dir = "v2024.10/board_bigtreetech-cb2";
    patches = [
      "patches/uboot/v2024.10/board_bigtreetech-cb2/bigtreetech-cb2-dts-and-defconfig.patch"
    ];
    source_hash = "sha256-UPy7XM1NGjbEt+pQr4oQrzD7wWWEtYDOPWTD+CNYMHs=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk35/rk3568_bl31_v1.44.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3566_ddr_1056MHz_v1.21.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
