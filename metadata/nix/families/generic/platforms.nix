{
  "generic-current" = {
    arch = "armhf";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.6.y";
      config = "linux--current";
      config_path = "config/kernel/linux--current.config";
      exact_version = "6.6.160";
      hash = "sha256-Bvhz+bnqwNE4wv6l0Cx9OXRa5E6nqP49TsjIqn3wlPY=";
      major_minor = "6.6";
      nvfetcher_key = "kernel-generic-branch-linux-6-6-y";
      patch_dir = "archive/\${LINUXFAMILY}-6.6";
      patches = [ ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = null;
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2024.07";
      config = "mt7623n_bpir2_defconfig";
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
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-mJ2TBy0Y5ZtcGFgtU5RKr0UDUp5FWzojbFb+o/ebRJU=";
      target_map = ";;packages/blobs/mt7623n/BPI-R2-HEAD440-0k.img packages/blobs/mt7623n/BPI-R2-HEAD1-512b.img packages/blobs/mt7623n/BPI-R2-preloader-2k.img packages/blobs/mt7623n/BPI-R2-EMMC-boot0-0K-0905.img u-boot.bin";
    };
  };
  "generic-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-\${KERNEL_MAJOR_MINOR}.y";
      config = "linux--edge";
      config_path = "config/kernel/linux--edge.config";
      exact_version = null;
      hash = null;
      major_minor = null;
      nvfetcher_key = "kernel-generic-branch-linux-kernel-major-minor-y";
      patch_dir = "archive/\${LINUXFAMILY}-\${KERNEL_MAJOR_MINOR}";
      patches = [ ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = null;
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = "imx8mp";
      atf_source = null;
      atf_target_map = "PLAT=imx8mp IMX_BOOT_UART_BASE=0x30a60000 bl31;;build/imx8mp/release/bl31.bin";
      branch = "tag:v2022.07";
      config = "tqma8mpxl_multi_mba8mpxl_defconfig";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = null;
      patches = null;
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = "flash.bin;;flash.bin";
    };
  };
  "generic-vendor" = {
    arch = "arm64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:rk-6.1-rkr5.1";
      config = "linux--vendor";
      config_path = "config/kernel/linux--vendor.config";
      exact_version = "6.1.115";
      hash = "sha256-xXNk7mpxRQfPViPol3PXCliJf8xfPuSc0yNcrdbCVJY=";
      major_minor = "6.1";
      nvfetcher_key = "kernel-generic-branch-rk-6-1-rkr5-1";
      patch_dir = "rk35xx-vendor-6.1";
      patches = [ "patches/kernel/rk35xx-vendor-6.1/001-hid-sony.patch" ];
      source = "https://github.com/armbian/linux-rockchip.git";
    };
    linux_family = null;
    uboot = {
      atf_branch = "tag:v2.13.0";
      atf_hash = "sha256-rxm5RCjT/MyMCTxiEC8jQeFMrCggrb2DRbs/qDPXb20=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-tag-v2-13-0";
      atf_platform = null;
      atf_source = "https://github.com/ARM-software/arm-trusted-firmware";
      atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr armsom-cm5-io-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr armsom-cm5-io-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
      branch = "branch:next-dev-v2024.10";
      config = "armsom-cm5-io-rk3576_defconfig";
      nvfetcher_key = "uboot-branch-next-dev-v2024-10";
      patch_dir = "legacy/u-boot-radxa-rk35xx";
      patches = [
        "patches/uboot/legacy/u-boot-radxa-rk35xx/add-board-nanopi-r76s.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_armsom-sige3/add-u-boot-pd-negotiation-support.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_armsom-sige5/add-u-boot-pd-negotiation-support.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_armsom-sige7/add-u-boot-pd-negotiation-support.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_dshanpi-a1/u-boot-add-dshanpi-a1-rk3576-dts.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_firefly-itx-3588j/board-firefly-itx-3588j-config.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_hinlink-h88k/uboot-hinlink-h88k-config.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_mekotronics-r58x-pro/5000-use-serial-as-base-for-MAC-address-find-serial-first-then-ethaddr-add-a-lot-of-debugging.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_mekotronics-r58x-pro/5001-boot_rkimg-don-t-try-rockchip_u2phy_vbus_detect-when-RECOVERY-button-pressed.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_mixtile-blade3/5000-Fixed-restart-issues-with-pd-adapter.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_mixtile-blade3/5001-fix-power_delivery-driver-affects-adb-to-enter-loader-mode.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_mixtile-blade3/5002-use-serial-as-base-for-MAC-address-find-serial-first-then-ethaddr-add-a-lot-of-debugging-adapted-for-Mixtile.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_rock-3a/add-trust-ini.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/board_rock-5c/reopen_disabled_nodes.patch"
        "patches/uboot/legacy/u-boot-radxa-rk35xx/rk3566-Add-rk3566-to-soc-name.patch"
      ];
      source = "https://github.com/radxa/u-boot.git";
      source_hash = "sha256-4l2foG3RkKvKKQfvHfFRvY5p5c85Wa2tRyyCITMp6wo=";
      target_map = "BL32=cache/sources/rkbin-tools/\${BL32_BLOB} BL31=cache/sources/rkbin-tools/rk33/rk3308_bl31_v2.22.elf ROCKCHIP_TPL=cache/sources/rkbin-tools/rk33/rk3308_ddr_589MHz_uart2_m1_v1.30.bin;;u-boot-rockchip.bin tpl/u-boot-tpl.bin spl/u-boot-spl.bin u-boot.itb rkspi_loader.img rkspi_loader.img";
    };
  };
}
