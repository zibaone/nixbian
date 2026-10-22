{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "bananapim2pro";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2024.07";
    config = "bananapi-m2-pro_defconfig";
    nvfetcher_key = "uboot-tag-v2024-07";
    patch_dir = "v2024.07";
    patches = [
      "patches/uboot/v2024.07/0050-automatically-add-chosen-kaslr-seed-and-deduplicate-code.patch"
      "patches/uboot/v2024.07/board_bananapir2/enable-boot-from-ext4.patch"
      "patches/uboot/v2024.07/board_orangepi5-plus/orangepi5-plus_kaslrseed.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk3228-hdmi-clk-fixes.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk3228-hdmi-driver.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk3228-inno-phy-driver.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk3228-vop-driver.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk322x-add-usb-reset-props.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk322x-box-add-defconfig.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk322x-box-add-device-tree-makefile.patch"
      "patches/uboot/v2024.07/board_rk322x-box/rk322x-box-add-device-tree.patch"
      "patches/uboot/v2024.07/board_rk322x-box/u-boot-1002-support-rockchip-gmac-rmii.patch"
      "patches/uboot/v2024.07/board_rk322x-box/u-boot-1005-support-rockchip-tee-binary.patch"
      "patches/uboot/v2024.07/board_rk322x-box/u-boot-1006-usbphy-otg-ehci-support.patch"
      "patches/uboot/v2024.07/board_rk3318-box/general-support-rmii-integrated-phy.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3318-box-add-defconfig.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3318-box-add-dts.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3318-box-add-makefile.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3328-add-usb-reset-props.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3328-resets-for-mmc-controllers.patch"
      "patches/uboot/v2024.07/board_rk3318-box/rk3328-sdmmc_ext-node.patch"
      "patches/uboot/v2024.07/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
      "patches/uboot/v2024.07/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
      "patches/uboot/v2024.07/board_xt-q8l-v10/xt-q8l-v10-defconfig.patch"
      "patches/uboot/v2024.07/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
      "patches/uboot/v2024.07/board_xt-q8l-v10/xt-q8l-v10-device-tree.patch"
      "patches/uboot/v2024.07/general-btrfs-fix-out-of-bounds-write.patch"
      "patches/uboot/v2024.07/general-dw-hdmi-disable.patch"
      "patches/uboot/v2024.07/general-dwc-otg-usb-fix.patch"
      "patches/uboot/v2024.07/general-fix-inno-phy-macro.patch"
      "patches/uboot/v2024.07/rockchip-fix-rng-seed.patch"
    ];
    source_hash = "sha256-mJ2TBy0Y5ZtcGFgtU5RKr0UDUp5FWzojbFb+o/ebRJU=";
  };
}
