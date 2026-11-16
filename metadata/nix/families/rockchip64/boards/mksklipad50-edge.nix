{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "mksklipad50";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr mksklipad50-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr mksklipad50-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2025.01";
    config = "mksklipad50-rk3328_defconfig";
    nvfetcher_key = "uboot-tag-v2025-01";
    patch_dir = "v2025.01";
    patches = [
      "patches/uboot/v2025.01/board_bananapicm4io/001-configs-bananapi-cm4-cm4io_defconfig-nvme-support.patch"
      "patches/uboot/v2025.01/board_bananapicm4io/002-configs-bananapi-cm4-cm4io_defconfig-preboot-and-boot-logo.patch"
      "patches/uboot/v2025.01/board_bananapicm4io/003-configs-bananapi-cm4-cm4io_defconfig-sata-support.patch"
      "patches/uboot/v2025.01/board_bananapim2s/001-bananapi-m2s-fixup.patch"
      "patches/uboot/v2025.01/board_bananapim2s/002-configs-bananapi-m2s_defconfig-preboot-and-boot-logo.patch"
      "patches/uboot/v2025.01/board_gateway-gz80x/001-Add-board-Amper-Gateway-AM-GZ80x.patch"
      "patches/uboot/v2025.01/board_gateway-gz80x/002-HACK-mmc-meson-gx-limit-to-24MHz.patch"
      "patches/uboot/v2025.01/board_gateway-gz80x/003-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
      "patches/uboot/v2025.01/board_gateway-gz80x/004-HACK-meson64-boot-target-usb.patch"
      "patches/uboot/v2025.01/board_mksklipad50/01-rk3328-mksklipad50-add-defconfig.patch"
      "patches/uboot/v2025.01/board_mksklipad50/02-rk3328-mksklipad50-add-uboot-dts.patch"
      "patches/uboot/v2025.01/board_mksklipad50/03-rk3328-mksklipad50-uboot-dwc3.patch"
      "patches/uboot/v2025.01/board_mksklipad50/04-rk3328-mksklipad50-add-trust-ini.patch"
      "patches/uboot/v2025.01/board_nanopi-r2s-plus/001.add-trust-ini.patch"
      "patches/uboot/v2025.01/board_orangepi4-lts/board-orangepi4-rockchip-tpl.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk3228-hdmi-clk-fixes.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk3228-hdmi-driver.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk3228-inno-phy-driver.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk3228-vop-driver.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk322x-add-usb-reset-props.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk322x-box-add-defconfig.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk322x-box-add-device-tree-makefile.patch"
      "patches/uboot/v2025.01/board_rk322x-box/rk322x-box-add-device-tree.patch"
      "patches/uboot/v2025.01/board_rk322x-box/u-boot-1002-support-rockchip-gmac-rmii.patch"
      "patches/uboot/v2025.01/board_rk322x-box/u-boot-1005-support-rockchip-tee-binary.patch"
      "patches/uboot/v2025.01/board_rk322x-box/u-boot-1006-usbphy-otg-ehci-support.patch"
      "patches/uboot/v2025.01/board_rk3318-box/general-support-rmii-integrated-phy.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3318-box-add-defconfig.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3318-box-add-dts.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3318-box-add-makefile.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3328-add-usb-reset-props.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3328-resets-for-mmc-controllers.patch"
      "patches/uboot/v2025.01/board_rk3318-box/rk3328-sdmmc_ext-node.patch"
      "patches/uboot/v2025.01/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
      "patches/uboot/v2025.01/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
      "patches/uboot/v2025.01/board_xt-q8l-v10/xt-q8l-v10-defconfig.patch"
      "patches/uboot/v2025.01/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
      "patches/uboot/v2025.01/board_xt-q8l-v10/xt-q8l-v10-device-tree.patch"
      "patches/uboot/v2025.01/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2025.01/general-dw-hdmi-disable.patch"
      "patches/uboot/v2025.01/general-dwc-otg-usb-fix.patch"
      "patches/uboot/v2025.01/rk3288-fix-kernel-iommu-page-fault.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-G3yK6F6asu2MKC/xjp14tSlrG48lc76whwj2aJdBO8Q=";
  };
}
