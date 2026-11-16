{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "odroidxu4";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:odroid-6.6.y";
    exact_version = "6.6.121";
    hash = "sha256-3BlUh0NrwfdLOX5aVh3vYqvpgkSubP/MSSX/exbUoBA=";
    nvfetcher_key = "kernel-generic-branch-odroid-6-6-y";
    patch_dir = "archive/odroidxu4-6.6";
    patches = [
      "patches/kernel/archive/odroidxu4-6.6/0001-Reverting-headers-install-patch.patch"
      "patches/kernel/archive/odroidxu4-6.6/add-gpio-line-names.patch"
      "patches/kernel/archive/odroidxu4-6.6/fix-gpio-line-names.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.121-122.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.122-123.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.123-124.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.124-125.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.125-126.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.126-127.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.127-128.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.128-129.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.129-130.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.130-131.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.131-132.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.132-133.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.133-134.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.134-135.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.135-136.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.136-137.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.137-138.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.138-139.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.139-140.patch"
      "patches/kernel/archive/odroidxu4-6.6/patch-6.6.140-141.patch"
    ];
    source = "https://github.com/hardkernel/linux";
  };
  kernel_params = null;
  uboot = {
    branch = "branch:odroidxu4-v2017.05";
    config = "odroid-xu4_defconfig";
    nvfetcher_key = "uboot-branch-odroidxu4-v2017-05";
    patch_dir = "legacy";
    patches = [
      "patches/uboot/legacy/board_imx7sabre/u-boot-enable-CMD_IMPORTENV.patch"
      "patches/uboot/legacy/board_imx7sabre/u-boot-remove-predefined-mmcroot.patch"
      "patches/uboot/legacy/board_imx7sabre/u-boot-update-boot-scripts.patch"
      "patches/uboot/legacy/board_indiedroid-nova/fix-compilation-on-noble.patch"
      "patches/uboot/legacy/board_miqi/0001-fixing-dtc-error.patch"
      "patches/uboot/legacy/board_miqi/101-u-boot-0003-rockchip-miqi-enable-led-gpio_keyboard.patch"
      "patches/uboot/legacy/board_miqi/libfdt_fix.patch"
      "patches/uboot/legacy/board_miqi/miqi-boot-alias.patch"
      "patches/uboot/legacy/board_odroidc1/000-olddefconfig-odroidc.patch"
      "patches/uboot/legacy/board_odroidc1/0002-sd_fusing-tweaks.patch"
      "patches/uboot/legacy/board_odroidc1/0003-compiler_gcc-do-not-redefine-__gnu_attributes.patch"
      "patches/uboot/legacy/board_odroidc1/0004-compiler-.h-sync-include-linux-compiler-.h-with-Linu.patch"
      "patches/uboot/legacy/board_odroidc1/0005-compiler_gcc-prevent-redefining-attributes.patch"
      "patches/uboot/legacy/board_odroidc1/0006-compiler-.h-sync-include-linux-compiler-.h-with-Linu.patch"
      "patches/uboot/legacy/board_odroidc1/0007-ARM-asm-io.h-use-static-inline.patch"
      "patches/uboot/legacy/board_odroidc1/0008-arm-board-use-__weak.patch"
      "patches/uboot/legacy/board_odroidc1/0009-add-vframe_provider_s-definition.patch"
      "patches/uboot/legacy/board_odroidc1/0010-common-main.c-make-show_boot_progress-__weak.patch"
      "patches/uboot/legacy/board_odroidc1/0011-wait_ms-fix.patch"
      "patches/uboot/legacy/board_odroidc1/cfgload-boot-ext4-improvements.patch"
      "patches/uboot/legacy/board_odroidc1/ext4fs-fix-invalid-extent-block-error.patch"
      "patches/uboot/legacy/board_odroidc1/fix_build_for_recent_host-side_libfdt.patch"
      "patches/uboot/legacy/board_odroidxu4/enable-distro-bootcmd.patch"
      "patches/uboot/legacy/board_odroidxu4/fix-compilation-on-noble.patch"
      "patches/uboot/legacy/board_odroidxu4/fix_build_for_recent_host-side_libfdt.patch"
      "patches/uboot/legacy/board_odroidxu4/use-armv7a-for-modern-toolchain.patch"
      "patches/uboot/legacy/board_orangepi5pro/fix-noble-build.patch"
      "patches/uboot/legacy/board_orangepizero2/u-boot-sun50iw9-legacy.patch"
      "patches/uboot/legacy/board_rockpi-s/0001-fixing-dtc-error.patch"
      "patches/uboot/legacy/board_rockpi-s/add-trust-ini.patch"
      "patches/uboot/legacy/board_rockpi-s/compiler_adjustements.patch"
      "patches/uboot/legacy/u-boot-clearfog/0001-fixing-dtc-error.patch"
      "patches/uboot/legacy/u-boot-clearfog/add-boot-marvell.cmd-backward-compatibility.patch"
      "patches/uboot/legacy/u-boot-clearfog/arm-mvebu-add-rev-id-a38x-b0.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogbase/do_pcie_reset_during_init.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogbase/enable_base_model.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogpro/do_pcie_reset_during_init.patch"
      "patches/uboot/legacy/u-boot-clearfog/enable-pcie-support.patch"
      "patches/uboot/legacy/u-boot-clearfog/libfdt_fix.patch"
      "patches/uboot/legacy/u-boot-clearfog/swap-sata-serdes-rx.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_mmc/set_default_boot_target_to_mmc.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_sata/set_default_boot_target_to_sata.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_sdhc/set_default_boot_target_to_sdhc.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_spi/set_default_boot_target_to_spi.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_uart/set_default_boot_target_to_uart.patch"
      "patches/uboot/legacy/u-boot-clearfog/use-armv7a-for-modern-toolchain.patch"
      "patches/uboot/legacy/u-boot-imx6/board_cubox-i/change_logo_to_armbian.patch"
      "patches/uboot/legacy/u-boot-imx6/board_udoo/udoo-adjust-env.patch"
      "patches/uboot/legacy/u-boot-imx6/board_wandboard/0001-wandboard-uEnv.txt-bootz-n-fixes.patch"
      "patches/uboot/legacy/u-boot-imx6/libfdt_fix.patch"
      "patches/uboot/legacy/u-boot-imx6/target_sata/enable_sata.patch"
      "patches/uboot/legacy/u-boot-imx6/target_sdhc/enable_sdhc.patch"
      "patches/uboot/legacy/u-boot-imx6/target_spi/enable_spi.patch"
      "patches/uboot/legacy/u-boot-imx6/use-armv7a-for-modern-toolchain.patch"
      "patches/uboot/legacy/u-boot-khadas-edge2-rk3588/0001-fix-tee.bin-not-found-error.patch"
      "patches/uboot/legacy/u-boot-khadas-edge2-rk3588/0002-Fix-build-errors.patch"
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
      "patches/uboot/legacy/u-boot-rockchip-buildroot/fix-source-cmd.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-bootscr.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-malloc_8_hide_optee.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-mem_layout.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/use-armv7a-for-modern-toolchain.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/001-MBR-support.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/002-SpacemiT-K1X-Fixups.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/003-SpacemiT-K1X-Defconfig-Fixups.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/004-Add-syslinux-script-and-uefi-support.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/005-Orange-Pi-RV2-u-boot-support-for-XM25QU128C-flash.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/006-orangepi-rv2-r2s-fit.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/007-efi_loader-suppress-error-print-message.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/008-Quiet-MBR-support.patch"
      "patches/uboot/legacy/u-boot-spacemit-k1/009-Fixup-circular-deps.patch"
      "patches/uboot/legacy/u-boot-tinkerboard2/add-board-tinker-board-2.patch"
    ];
    source = "https://github.com/hardkernel/u-boot.git";
    source_hash = "sha256-hIsc0pCqeyLse5NTFxXjeiEuZo/iyaf+vEfb8gMLYhQ=";
    target_map = ";;sd_fuse/bl1.bin.hardkernel sd_fuse/bl2.bin.hardkernel.720k_uboot u-boot-dtb.bin sd_fuse/tzsw.bin.hardkernel";
  };
}
