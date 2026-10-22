{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "nanopineo3";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr nanopi-r2s-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr nanopi-r2s-rk3328_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "nanopi-r2s-rk3328_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "u-boot-rockchip64-v2022.04";
    patches = [
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-clockworkpi-a06.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-helios64.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-nanopi-m4v2.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-orangepi-4.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-orangepi-r1-plus-0.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-orangepi-r1-plus-lts.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-board-rock-pi-s.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/add-trust-ini.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-nanopi-r4se.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-pinebook-pro-0001-usb-regulator.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-pinebook-pro-0002-light-up-leds.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-pinebook-pro-0003-spi-flash-support.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-pinebook-pro-0005-panel-reset.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-pinebook-pro-0007-increase-nvme-timeout.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-rock-pi-4-enable-spi-flash.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-rockpro64-advanced-recovery.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board-rockpro64-disable-preboot.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_nanopi-r4s/zzz-0001-rockchip-rk3399-Add-Nanopi-R4S-board-support.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_nanopi-r4s/zzz-0002-rockchip-rk3399-split-nanopi-r4s-out-of-evb_rk3399.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_nanopi-r4s/zzz-0003-ram-rk3399-Add-support-for-multiple-DDR-types.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_nanopi-r4s/zzz-0004-board-nanopi4-unify-1GB-4GB-variants-of-R4S.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_nanopi-r4s/zzz-0005-board-nanopi-r4s-adjust-for-v2022.04.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_rk3318-box/rk3318-box-add-defconfig.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_rk3318-box/rk3318-box-add-dts.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_rk3318-box/rk3318-box-add-makefile.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_rock-s0/add-board-rock-s0.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_rockpi-s/u-boot-rock-pi-s-console0.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-m1/u-boot-0010-rk-usb-start.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-m1/u-boot-rk-rk3328-roc-pc-config.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-m1/u-boot-rk-rk3328-roc-pc-dts.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-m1/u-boot-rk-rk3328-roc-pc-include.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-m1/u-boot-rk-rk3328-roc-pc-make-dts.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/board_station-p1/u-boot-rk3399-roc-pc-plus.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/enable-DT-overlays-support.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-add-xtx-spi-nor-chips.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-dwc-otg-usb-fix.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-fix-use-semantic-versioning.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-set-eth1addr.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-support-recovery-button.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/general-support-rmii-integrated-phy.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/nanopi-r2s-rk3328_defconfig-0001-enable-setexpr-fmt-regex.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3328-efuse-driver.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3328-resets-for-mmc-controllers.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3328-sdmmc_ext-node.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-always-init-rkclk.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-disable-hdmi-roc-pc.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-disable-hdmi.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-enable-stable-mac.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-nanopc-t4-use-1600MHz-sdram-configuration.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/rk3399-populate-child-node-of-syscon.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/sdmmc-force-fifo-mode-in-spl.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/u-boot-rk-rk3399-usb-start-firefly-rk3399.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/u-boot-rk-rk3399-usb-start-nanopc-t4.patch"
      "patches/uboot/u-boot-rockchip64-v2022.04/u-boot-rk-rk3399-usb-start.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
  };
}
