{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "qidi-x6";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr qidi-x6-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr qidi-x6-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2026.04";
    config = "qidi-x6-rk3328_defconfig";
    nvfetcher_key = "uboot-tag-v2026-04";
    patch_dir = "v2026.04";
    patches = [
      "patches/uboot/v2026.04/1001-fdt_fixup_ethernet-add-logs.patch"
      "patches/uboot/v2026.04/board_h96-tvbox-3566/0001-arm64-dts-rockchip-add-rk3568-h96max-v56.patch"
      "patches/uboot/v2026.04/board_h96-tvbox-3566/0002-configs-add-h96max-v56-defconfig.patch"
      "patches/uboot/v2026.04/board_h96-tvbox-3566/0003-rockchip-boot-mode-tune-download-key-for-h96-tvbox-3566.patch"
      "patches/uboot/v2026.04/board_helios4/0001-ARMADA-A388-SOM-U-Boot-ODT-Update.patch"
      "patches/uboot/v2026.04/board_helios4/0002-Add-RTC-to-helios4.patch"
      "patches/uboot/v2026.04/board_helios4/0003-add-boot-marvell.cmd-backward-compatibility.patch"
      "patches/uboot/v2026.04/board_helios4/0004-arm-dts-armada-38x-Fix-broken-SPI-support-after-dts-sync.patch"
      "patches/uboot/v2026.04/board_helios4/0006-enable-DT-overlays-support.patch"
      "patches/uboot/v2026.04/board_helios4/0007-helios4_defconfig-0002-enable-setexpr-command.patch"
      "patches/uboot/v2026.04/board_helios4/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2026.04/board_helios4/target_spi/0101-helios4-config-set-boot-device-spinor.patch"
      "patches/uboot/v2026.04/board_helios4/target_spi/0102-helios4-reorder-boot-device.patch"
      "patches/uboot/v2026.04/board_helios4/target_uart/0201-helios4-prepare-for-uart-image.patch"
      "patches/uboot/v2026.04/board_helios64/1000-exception-include-string.patch"
      "patches/uboot/v2026.04/board_helios64/1001-helios64-enable-target.patch"
      "patches/uboot/v2026.04/board_helios64/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2026.04/board_helios64/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2026.04/board_nanopi-m5/0001-arm64-dts-rockchip-enable-UFS-controller-NanoPi-M5.patch"
      "patches/uboot/v2026.04/board_nanopi-m5/0002-rockchip-rk3576-nanopi-m5-Enable-UFS-support.patch"
      "patches/uboot/v2026.04/board_nanopi-r3s-lts/Add-board-NanoPi-R3S-LTS.patch"
      "patches/uboot/v2026.04/board_nanopi-r76s/add-nanopi-r76s-support.patch"
      "patches/uboot/v2026.04/board_odroidhc4/odroid-sm1-hc4-regulator-boot-on.patch"
      "patches/uboot/v2026.04/board_odroidhc4/odroidhc4-boot-usb-sata-sd.patch"
      "patches/uboot/v2026.04/board_odroidn2/0001-mmc-meson_gx_mmc-limit-f_max-to-24-MHz.patch"
      "patches/uboot/v2026.04/board_odroidn2/meson64-boot-usb-nvme-scsi-first.patch"
      "patches/uboot/v2026.04/board_orangepi4-lts/board-orangepi4-rockchip-tpl.patch"
      "patches/uboot/v2026.04/board_photonicat2/add-photonicat2-board.patch"
      "patches/uboot/v2026.04/board_qidi-x6/01-qidi-x6-rk3328-add-defconfig.patch"
      "patches/uboot/v2026.04/board_qidi-x6/02-qidi-x6-rk3328-add-dts.patch"
      "patches/uboot/v2026.04/board_qidi-x6/03-qidi-x6-rk3328-add-u-boot-dtsi.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk3228-hdmi-clk-fixes.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk3228-hdmi-driver.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk3228-inno-phy-driver.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk3228-vop-driver.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk322x-add-usb-reset-props.patch"
      "patches/uboot/v2026.04/board_rk322x-box/rk322x-box-add-device-tree-makefile.patch"
      "patches/uboot/v2026.04/board_rk322x-box/u-boot-1002-support-rockchip-gmac-rmii.patch"
      "patches/uboot/v2026.04/board_rk322x-box/u-boot-1005-support-rockchip-tee-binary.patch"
      "patches/uboot/v2026.04/board_rk322x-box/u-boot-1006-usbphy-otg-ehci-support.patch"
      "patches/uboot/v2026.04/board_rk3318-box/general-support-rmii-integrated-phy.patch"
      "patches/uboot/v2026.04/board_rk3318-box/rk3318-box-add-makefile.patch"
      "patches/uboot/v2026.04/board_rk3318-box/rk3328-add-usb-reset-props.patch"
      "patches/uboot/v2026.04/board_rk3318-box/rk3328-fix-missing-hdmi-os.patch"
      "patches/uboot/v2026.04/board_rock-5-itx/0001-arm-dts-rockchip-rock-5-itx-drop-pcie-refclk-from-u-boot-dtsi.patch"
      "patches/uboot/v2026.04/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
      "patches/uboot/v2026.04/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
      "patches/uboot/v2026.04/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
      "patches/uboot/v2026.04/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2026.04/general-dw-hdmi-disable.patch"
      "patches/uboot/v2026.04/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2026.04/general-reset-rockchip-make-device-resets-available-in-SPL.patch"
      "patches/uboot/v2026.04/general-rk3588-add-i2s-mclk-output-to-io-clock-ids.patch"
      "patches/uboot/v2026.04/general-rockchip-spl-Add-support-for-booting-from-UFS.patch"
      "patches/uboot/v2026.04/general-spl-Make-UFS-available-for-SPL-builds.patch"
      "patches/uboot/v2026.04/general-ufs-rockchip-Add-device-reset-support.patch"
      "patches/uboot/v2026.04/rk3288-fix-kernel-iommu-page-fault.patch"
      "patches/uboot/v2026.04/rk3576-arm64-dts-Explicitly-request-UFS-reset-pin.patch"
      "patches/uboot/v2026.04/rk3576-ufs-rockchip-Hard-reset-controller-on-init.patch"
    ];
    source_hash = "sha256-rRw3rtZYVmXYy22QJZY+wWymgxItzRi3axnrNt29ga4=";
  };
}
