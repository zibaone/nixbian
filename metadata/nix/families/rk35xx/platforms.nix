{
  "rk35xx-vendor" = {
    arch = "arm64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:rk-6.1-rkr5.1";
      config = "linux-rk35xx-vendor";
      config_path = "config/kernel/linux-rk35xx-vendor.config";
      config_path_nix = "configs/linux-rk35xx-vendor.config";
      exact_version = "6.1.115";
      hash = "sha256-xXNk7mpxRQfPViPol3PXCliJf8xfPuSc0yNcrdbCVJY=";
      major_minor = "6.1";
      nvfetcher_key = "kernel-rk35xx-branch-rk-6-1-rkr5-1";
      patch_dir = "rk35xx-vendor-6.1";
      patches = [ "patches/kernel/rk35xx-vendor-6.1/001-hid-sony.patch" ];
      source = "https://github.com/armbian/linux-rockchip.git";
    };
    linux_family = "rk35xx";
    uboot = {
      atf_branch = "tag:v2.13.0";
      atf_hash = "sha256-rxm5RCjT/MyMCTxiEC8jQeFMrCggrb2DRbs/qDPXb20=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-tag-v2-13-0";
      atf_platform = null;
      atf_source = "https://github.com/ARM-software/arm-trusted-firmware";
      atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr armsom-aim7-io-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr armsom-aim7-io-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
      branch = "branch:next-dev-v2024.10";
      config = "armsom-aim7-io-rk3588_defconfig";
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
