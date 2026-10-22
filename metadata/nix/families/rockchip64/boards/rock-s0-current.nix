{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "rock-s0";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr rock-s0-rk3308_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr rock-s0-rk3308_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "rock-s0-rk3308_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "v2024.10";
    patches = [
      "patches/uboot/v2024.10/0010-general-dw-hdmi-disable.patch"
      "patches/uboot/v2024.10/0011-general-dwc-otg-usb-fix.patch"
      "patches/uboot/v2024.10/1010-rockchip-fix-rng-seed.patch"
      "patches/uboot/v2024.10/board_bigtreetech-cb2/bigtreetech-cb2-dts-and-defconfig.patch"
      "patches/uboot/v2024.10/board_dshanpi-r1/0001-add-support-for-dshanpi-r1.patch"
      "patches/uboot/v2024.10/board_gateway-gz80x/001-Add-board-Amper-Gateway-AM-GZ80x.patch"
      "patches/uboot/v2024.10/board_gateway-gz80x/002-HACK-mmc-meson-gx-limit-to-24MHz.patch"
      "patches/uboot/v2024.10/board_gateway-gz80x/003-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
      "patches/uboot/v2024.10/board_gateway-gz80x/004-HACK-meson64-boot-target-usb.patch"
      "patches/uboot/v2024.10/board_longanpi-3h/0006-add-lpi3h-defconfig-and-dts.patch"
      "patches/uboot/v2024.10/board_longanpi-3h/0007-lpi3h-drivers-emmc-add-emmc-boot-support.patch"
      "patches/uboot/v2024.10/board_nanopi-r3s/0001-rockchip-rk3566-add-nanopi-r3s.patch"
      "patches/uboot/v2024.10/board_orangepi4-lts/board-orangepi4-rockchip-tpl.patch"
      "patches/uboot/v2024.10/board_rock-s0/1120-mmcBootOnRockS0v1-1.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
    target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.26.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3308_ddr_589MHz_uart0_m0_v2.07.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
  };
}
