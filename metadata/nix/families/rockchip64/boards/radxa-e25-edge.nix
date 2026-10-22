{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "radxa-e25";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr radxa-e25-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr radxa-e25-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "branch:next-dev-v2024.10";
    config = "radxa-e25-rk3568_defconfig";
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
  };
}
