{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "gateway-gz80x";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2024.10";
    config = "amper_gateway_am-gz80x_defconfig";
    nvfetcher_key = "uboot-tag-v2024-10";
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
    source_hash = "sha256-UPy7XM1NGjbEt+pQr4oQrzD7wWWEtYDOPWTD+CNYMHs=";
    target_map = "u-boot-dtb.img;;u-boot.bin u-boot-dtb.img";
  };
}
