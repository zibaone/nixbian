{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "pineh64-b";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_platform = "sun50i_h6";
    atf_target_map = "PLAT=sun50i_h6 DEBUG=1 bl31;;build/sun50i_h6/debug/bl31.bin";
    branch = "tag:v2022.07";
    config = "pine_h64_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "u-boot-sunxi u-boot-sunxi-crust";
    patches = [
      "patches/uboot/u-boot-sunxi/Allwinner-Fix-incorrect-ram-size-detection-for-H6-boards.patch"
      "patches/uboot/u-boot-sunxi/allwinner-a10-fix-pmu-irq-number.patch"
      "patches/uboot/u-boot-sunxi/allwinner-add-support-for-Recore.patch"
      "patches/uboot/u-boot-sunxi/allwinner-boot-splash.patch"
      "patches/uboot/u-boot-sunxi/allwinner-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/allwinner-enable-autoboot-keyed.patch"
      "patches/uboot/u-boot-sunxi/allwinner-enable-r_pio-gpio-access-h3-h5.patch"
      "patches/uboot/u-boot-sunxi/allwinner-fdt-setprop-fix-unaligned-access.patch"
      "patches/uboot/u-boot-sunxi/allwinner-h3-fix-pll1-setup-to-never-use-dividers.patch"
      "patches/uboot/u-boot-sunxi/allwinner-h3-set-safe-axi_apb-clock-dividers.patch"
      "patches/uboot/u-boot-sunxi/allwinner-h616-GPU-enable-hack.patch"
      "patches/uboot/u-boot-sunxi/allwinner-h616-THS-workaround.patch"
      "patches/uboot/u-boot-sunxi/allwinner-lower-default-DRAM-freq-A64-H5.patch"
      "patches/uboot/u-boot-sunxi/allwinner-sun8i-set-machid.patch"
      "patches/uboot/u-boot-sunxi/arm64-dts-sun50i-h6-orangepi.dtsi-Rollback-r_rsb-to-r_i2c.patch"
      "patches/uboot/u-boot-sunxi/board_bananapim2ultra/xxx-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/board_bananapim3/Add-MACH_SUN8I_A83T-to-can-calibrate.patch"
      "patches/uboot/u-boot-sunxi/board_bananapipro/Bananapro-01-add-hdmi-de-reg_ahci_5v.patch"
      "patches/uboot/u-boot-sunxi/board_bananapipro/Bananapro-02-add-AXP209-regulators.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/allwinner-h616-driver-i2c3.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/allwinner-h616-dts-enable-internal-phy-emac1.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/allwinner-h616-fix-error-boot-from-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/allwinner-h616-setup-internal-phy-emac1.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/bigtreetech-cb1-PC3-eMMC-selpin-set-to-pull-down-mode.patch"
      "patches/uboot/u-boot-sunxi/board_bigtreetech-cb1/bigtreetech-cb1-dts-and-deconfig.patch"
      "patches/uboot/u-boot-sunxi/board_cubietruck/add-a20-optional-eMMC.patch"
      "patches/uboot/u-boot-sunxi/board_cubietruck/adjust-default-dram-clockspeeds.patch"
      "patches/uboot/u-boot-sunxi/board_cubietruck/allwinner-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/board_inovato-quadra/allwinner-pwrled-config-option.patch"
      "patches/uboot/u-boot-sunxi/board_lime-a64/add-a64-olinuxino-emmc-support.patch"
      "patches/uboot/u-boot-sunxi/board_lime-a64/add-a64-olinuxino-spl-spi.patch"
      "patches/uboot/u-boot-sunxi/board_lime2/GMAC_TX_DELAY_autocorrection.patch"
      "patches/uboot/u-boot-sunxi/board_nanopi-r1/add-nanopi-r1-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_nanopiair/add-nanopi-air-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_nanopiair/adjust-small-boards-cpufreq.patch"
      "patches/uboot/u-boot-sunxi/board_nanopiduo/add-nanopi-duo.patch"
      "patches/uboot/u-boot-sunxi/board_nanopik1plus/add-xx-nanopi-k1-plus-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_nanopik1plus/allwinner-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/board_nanopim1plus2/add-nanopi-m1-plus2-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_nanopim1plus2/allwinner-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo/add-emmc_support_to_neo1_and_2.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo/add-nanopi-neo-core.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo/adjust-small-boards-cpufreq.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo2/add-emmc_support_to_neo1_and_2.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo2/add-xx-boot-auto-dt-select-neo2.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo2/adjust-default-dram-clockspeeds.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineo2black/add-xx-nanopineocore2.patch"
      "patches/uboot/u-boot-sunxi/board_nanopineocore2/add-xx-nanopineocore2.patch"
      "patches/uboot/u-boot-sunxi/board_olimex-som-a20/GMAC_TX_DELAY_autocorrection.patch"
      "patches/uboot/u-boot-sunxi/board_orangepi2/add-orangepi-plus2-emmc.patch"
      "patches/uboot/u-boot-sunxi/board_orangepi3-lts/0001-add-orange-pi-3-lts-support.patch"
      "patches/uboot/u-boot-sunxi/board_orangepiprime/enable-ethernet-orangepiprime.patch"
      "patches/uboot/u-boot-sunxi/board_orangepiwin/fix-usb1-vbus-opiwin.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero/add-orangepi-zero-usb-boot-support.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero/adjust-default-dram-clockspeeds.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero/adjust-small-boards-cpufreq.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero/allwinner-pwrled-config-option.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero2/orangepizero2_dts_set_bldo2_to_1.8v.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizero2/orangepizero2_light_red_led_on.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizeroplus/add-orangepi-zero-plus-pxe-support.patch"
      "patches/uboot/u-boot-sunxi/board_orangepizeroplus2-h3/add-orangepi-zeroplus2_h3.patch"
      "patches/uboot/u-boot-sunxi/board_pinebook-a64/pinebook-add-rare-panel-support.patch"
      "patches/uboot/u-boot-sunxi/board_pocketchip-sd/pocketchip-defconfig.patch"
      "patches/uboot/u-boot-sunxi/board_pocketchip-sd/pocketchip-dts-add-mmc2.patch"
      "patches/uboot/u-boot-sunxi/board_sunvell-r69/add-sunvell-r69.patch"
      "patches/uboot/u-boot-sunxi/board_sunvell-r69/allwinner-disable-de2-to-improve-edid-detection.patch"
      "patches/uboot/u-boot-sunxi/board_x96-mate/arm64-sun50i-h313-add-x96q-lpddr3-defconfig.patch"
      "patches/uboot/u-boot-sunxi/board_x96-mate/sunsi-add-h616-internal-eth-phy-support.patch"
      "patches/uboot/u-boot-sunxi/board_x96q/arm64-sun50i-h313-add-x96q-lpddr3-defconfig.patch"
      "patches/uboot/u-boot-sunxi/board_x96q/sunsi-add-h616-internal-eth-phy-support.patch"
      "patches/uboot/u-boot-sunxi/opizero3-1.5GB-trim-from-u-boot-v2024.01.patch"
      "patches/uboot/u-boot-sunxi-crust/h3-h5-fix-pinctrl-err-19.patch"
      "patches/uboot/u-boot-sunxi-crust/h3-scp.patch"
      "patches/uboot/u-boot-sunxi-crust/sunxi-Enable-remoteproc-on-H3.patch"
    ];
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
  };
}
