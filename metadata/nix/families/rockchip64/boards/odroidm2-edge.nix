{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "odroidm2";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr odroid-m2-rk3588s_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr odroid-m2-rk3588s_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "odroid-m2-rk3588s_defconfig";
    patch_dir = "v2025.10";
    patches = [
      "patches/uboot/v2025.10/board_9tripod-x3568-v4/0001-arm-rockchip-Add-support-for-the-9Tripod-X3568-v4.patch"
      "patches/uboot/v2025.10/board_dusun-dsom-010r/0001-Dusun-DSOM-010R-defconfig.patch"
      "patches/uboot/v2025.10/board_dusun-dsom-010r/0002-Dusun-DSOM-010R-device-tree.patch"
      "patches/uboot/v2025.10/board_helios4/0001-ARMADA-A388-SOM-U-Boot-ODT-Update.patch"
      "patches/uboot/v2025.10/board_helios4/0002-Add-RTC-to-helios4.patch"
      "patches/uboot/v2025.10/board_helios4/0003-add-boot-marvell.cmd-backward-compatibility.patch"
      "patches/uboot/v2025.10/board_helios4/0004-arm-dts-armada-38x-Fix-broken-SPI-support-after-dts-sync.patch"
      "patches/uboot/v2025.10/board_helios4/0005-arm-mvebu-helios4-Update-Load-address.patch"
      "patches/uboot/v2025.10/board_helios4/0006-enable-DT-overlays-support.patch"
      "patches/uboot/v2025.10/board_helios4/0007-helios4_defconfig-0002-enable-setexpr-command.patch"
      "patches/uboot/v2025.10/board_helios4/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2025.10/board_helios4/target_spi/0101-helios4-config-set-boot-device-spinor.patch"
      "patches/uboot/v2025.10/board_helios4/target_spi/0102-helios4-reorder-boot-device.patch"
      "patches/uboot/v2025.10/board_helios4/target_uart/0201-helios4-prepare-for-uart-image.patch"
      "patches/uboot/v2025.10/board_khadas-edge2/0001-khadas-edge2-add-support-for-KBI-and-apply-some-patc.patch"
      "patches/uboot/v2025.10/board_odroidm2/001-odroid-m2-fix-for-ethernet.patch"
      "patches/uboot/v2025.10/board_orangepi4-lts/board-orangepi4-rockchip-tpl.patch"
      "patches/uboot/v2025.10/board_orangepi5pro/0001-rockchip-rk3588-Add-support-for-the-OrangePI-5-Pro.patch"
      "patches/uboot/v2025.10/board_orangepi5pro/0002-net-dwc_eth_qos-Add-support-for-Motorcomm-YT6801.patch"
      "patches/uboot/v2025.10/board_orangepi5pro/0003-net-dwc_eth_qos-Allow-overriding-descriptor-size-and.patch"
      "patches/uboot/v2025.10/board_orangepi5pro/0004-rockchip-board-Skip-MAC-address-setup-for-Orange-Pi-.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk3228-hdmi-clk-fixes.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk3228-hdmi-driver.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk3228-inno-phy-driver.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk3228-vop-driver.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk322x-add-usb-reset-props.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk322x-box-add-defconfig.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk322x-box-add-device-tree-makefile.patch"
      "patches/uboot/v2025.10/board_rk322x-box/rk322x-box-add-device-tree.patch"
      "patches/uboot/v2025.10/board_rk322x-box/u-boot-1002-support-rockchip-gmac-rmii.patch"
      "patches/uboot/v2025.10/board_rk322x-box/u-boot-1005-support-rockchip-tee-binary.patch"
      "patches/uboot/v2025.10/board_rk322x-box/u-boot-1006-usbphy-otg-ehci-support.patch"
      "patches/uboot/v2025.10/board_rk3318-box/general-support-rmii-integrated-phy.patch"
      "patches/uboot/v2025.10/board_rk3318-box/rk3318-box-add-defconfig.patch"
      "patches/uboot/v2025.10/board_rk3318-box/rk3318-box-add-dts.patch"
      "patches/uboot/v2025.10/board_rk3318-box/rk3318-box-add-makefile.patch"
      "patches/uboot/v2025.10/board_rk3318-box/rk3328-add-usb-reset-props.patch"
      "patches/uboot/v2025.10/board_rk3318-box/rk3328-fix-missing-hdmi-os.patch"
      "patches/uboot/v2025.10/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
      "patches/uboot/v2025.10/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
      "patches/uboot/v2025.10/board_xt-q8l-v10/xt-q8l-v10-defconfig.patch"
      "patches/uboot/v2025.10/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
      "patches/uboot/v2025.10/board_xt-q8l-v10/xt-q8l-v10-device-tree.patch"
      "patches/uboot/v2025.10/board_youyeetoo-r1-v3/youyeetoo-r1-v3-add-support.patch"
      "patches/uboot/v2025.10/board_youyeetoo-r1-v3/youyeetoo-r1-v3-upstream-dts.patch"
      "patches/uboot/v2025.10/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2025.10/general-dw-hdmi-disable.patch"
      "patches/uboot/v2025.10/general-dwc-otg-usb-fix.patch"
      "patches/uboot/v2025.10/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2025.10/rk3288-fix-kernel-iommu-page-fault.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
  };
}
