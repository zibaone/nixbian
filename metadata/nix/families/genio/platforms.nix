{
  "genio-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "commit:1b251287c9f26c428033af1106319af5e32f376b";
      config = "linux-genio-edge";
      config_path = "config/kernel/linux-genio-edge.config";
      config_path_nix = "configs/linux-genio-edge.config";
      exact_version = null;
      hash = "sha256-V9xlmYy5g2q6GssSgKfLjwH+RdVJBkq/h0sH8DsxeE4=";
      major_minor = "6.19";
      nvfetcher_key = "kernel-genio-commit-1b251287c9f26c428033af1106319af5e32f376b";
      patch_dir = "archive/genio-6.19";
      patches = [ ];
      source = "https://gitlab.collabora.com/mediatek/aiot/linux.git";
    };
    linux_family = "genio";
    uboot = {
      atf_branch = "commit:decacb88cfe882cb09ddd613ecaf1323d3fe6c22";
      atf_hash = "sha256-u7TOsKNZG8n6wm0cH+1Zw77YVqs5wZEZ0sc4QnD18JU=";
      atf_nvfetcher_key = "src-trusted-firmware-a-commit-decacb88cfe882cb09ddd613ecaf1323d3fe6c22";
      atf_platform = null;
      atf_source = "https://gitlab.com/mediatek/aiot/bsp/trusted-firmware-a.git";
      atf_target_map = "\${common_tfa_args[*]} fip;;build/\${MEDIATEK_GENIO_SOC_PLATFORM/release/fip.bin";
      branch = "commit:40c563b0d2ba7e150085e195f23f4ed4adc81646";
      config = "genio_1200_radxa_nio_12l_d8_defconfig";
      nvfetcher_key = "uboot-commit-40c563b0d2ba7e150085e195f23f4ed4adc81646";
      patch_dir = "u-boot-genio";
      patches = [
        "patches/uboot/u-boot-genio/0001-GENIO-board-Fix-ramdisk-image-overlapping.patch"
        "patches/uboot/u-boot-genio/0002-GENIO-board-Match-upstream-kernel-device-tree-blob-n.patch"
        "patches/uboot/u-boot-genio/0003-GENIO-configs-genio-350-720-evk-Enable-LEGACY_IMAGE_.patch"
        "patches/uboot/u-boot-genio/0004-Fix-typo-in-CONFIG_USBNET_DEVADDR.patch"
        "patches/uboot/u-boot-genio/0005-usb-ether-Fix-error-handling-in-usb_ether_init.patch"
        "patches/uboot/u-boot-genio/0006-usb-gadget-Remove-non-DM_ETH-code.patch"
        "patches/uboot/u-boot-genio/0007-usb-gadget-ether-Inline-functions-used-once.patch"
        "patches/uboot/u-boot-genio/0008-usb-gadget-ether-Move-probe-function-above-driver-st.patch"
        "patches/uboot/u-boot-genio/0009-usb-gadget-ether-Handle-gadget-driver-registration-i.patch"
        "patches/uboot/u-boot-genio/0010-dm-usb-udc-Factor-out-plain-udevice-handler-function.patch"
        "patches/uboot/u-boot-genio/0011-usb-gadget-ether-Use-plain-udevice-for-UDC-controlle.patch"
        "patches/uboot/u-boot-genio/0012-GENIO-configs-genio-350-evk-Enable-CONFIG_WDT_MTK.patch"
        "patches/uboot/u-boot-genio/0013-GENIO-board-350-510-700-1200-EVK-Drop-deprecated-usb.patch"
        "patches/uboot/u-boot-genio/0014-GENIO-configs-350-510-700-1200-EVK-Enable-bind-comma.patch"
        "patches/uboot/u-boot-genio/0015-usb-gadget-ether-Set-USB-connect-timeout-to-20s.patch"
        "patches/uboot/u-boot-genio/0016-arm-dts-add-radxa-nio-12l.patch"
        "patches/uboot/u-boot-genio/0017-arm-dts-radxa-nio-12l-add-usb.patch"
        "patches/uboot/u-boot-genio/0018-configs-add-radxa-nio-12l-defconfig.patch"
        "patches/uboot/u-boot-genio/0019-radxa-nio-12l-use-upstream-dts.patch"
        "patches/uboot/u-boot-genio/0020-configs-fix-radxa-nio-12l-defconfig.patch"
        "patches/uboot/u-boot-genio/0021-include-configs-mt8195-set-scsi-as-first-boot-target.patch"
        "patches/uboot/u-boot-genio/0022-dts-radxa-nio-12l-enable-mmc1.patch"
        "patches/uboot/u-boot-genio/0023-watchdog-mtk_wdt-Correct-maximum-timeout-from-15-to-.patch"
        "patches/uboot/u-boot-genio/0024-Add-support-for-Grinn-GenioSBC-700.patch"
        "patches/uboot/u-boot-genio/0025-arm-dts-grinn-move-auxadc-node-into-board-device-tre.patch"
        "patches/uboot/u-boot-genio/0026-dts-configs-add-Grinn-GenioSBC-510.patch"
        "patches/uboot/u-boot-genio/0027-arch-mediatek-adjust-memory-size-at-runtime.patch"
        "patches/uboot/u-boot-genio/0028-board-configs-enable-fixup-fdt-memory-at-runtime-for.patch"
        "patches/uboot/u-boot-genio/3300-GENIO-arch-mediatek-1200-evk-radxa-nio-12l-adjust-memory-size-at-runtime-and-fixup-fdt.patch"
        "patches/uboot/u-boot-genio/3301-GENIO-mt8195-boot-order-SD-UFS-eMMC-USB-Network.patch"
        "patches/uboot/u-boot-genio/3302-GENIO-radxa-nio-12l-Enable-bind-command.patch"
        "patches/uboot/u-boot-genio/3303-UPSTREAM-usb-gadget-UMS-support-multiple-sector-sizes-plus-three-others.patch"
        "patches/uboot/u-boot-genio/3304-UPSTREAM-multiple-fixes-for-btrfs.patch"
        "patches/uboot/u-boot-genio/3305-GENIO-radxa-nio-12l-Enable-BTRFS-and-BZIP2-support.patch"
        "patches/uboot/u-boot-genio/3306-GENIO-mt8195-fdt_addr_r-kernel_addr_r-ramdisk_addr_r-for-large-kernels-initrds.patch"
      ];
      source = "https://gitlab.com/mediatek/aiot/bsp/u-boot.git";
      source_hash = "sha256-OBmMY6EBxUW4xLiBG3Tu2jLxmSB0jVkQhpmNf176tvE=";
      target_map = "all;;fip.img lk.bin";
    };
  };
}
