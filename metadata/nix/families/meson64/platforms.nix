{
  "meson64-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-meson64-current";
      config_path = "config/kernel/linux-meson64-current.config";
      config_path_nix = "configs/linux-meson64-current.config";
      exact_version = "6.18.38";
      hash = "sha256-S48YwJ0smqgblFkpCXNOIY3gRpsmEb8KubAlRjFxBV0=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-meson64-branch-linux-6-18-y";
      patch_dir = "archive/meson64-6.18";
      patches = [
        "patches/kernel/archive/meson64-6.18/board-bananapi-cm4-cm4io.patch"
        "patches/kernel/archive/meson64-6.18/board-bananapi-m2s.patch"
        "patches/kernel/archive/meson64-6.18/board-bananapim5-001-sd-use-270-mmc-clock-phase-via-dt.patch"
        "patches/kernel/archive/meson64-6.18/board-bananapim5-002-add-wifi-bt-support.patch"
        "patches/kernel/archive/meson64-6.18/board-bananapism1-add-uart_A-and-AO_B.patch"
        "patches/kernel/archive/meson64-6.18/board-khadas-vim3-add-npu-node.patch"
        "patches/kernel/archive/meson64-6.18/board-khadas-vim3-fix-missing-i2c3-nod.patch"
        "patches/kernel/archive/meson64-6.18/board-khadas-vims-add-rtc-vrtc-aliases.patch"
        "patches/kernel/archive/meson64-6.18/board-nanopi-k2-add-uartC-alias.patch"
        "patches/kernel/archive/meson64-6.18/board-nanopi-k2-enable-emmc.patch"
        "patches/kernel/archive/meson64-6.18/board-odroid-sm1-regulators-boot-on.patch"
        "patches/kernel/archive/meson64-6.18/board-odroid-sm1-reset.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidc2-add-uartA-uartC.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidc2-enable-SPI.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidc2-enable-scpi-dvfs.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidc2-usb-hub-disable-autosuspend-for-Genesys-Logic-.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidhc4-enable-fan1_input.patch"
        "patches/kernel/archive/meson64-6.18/board-odroidn2plus-Add-missing-CPU-opp.patch"
        "patches/kernel/archive/meson64-6.18/board-radxa-zero-dts-add-aliases-for-serial-i2c-and-spi.patch"
        "patches/kernel/archive/meson64-6.18/board-radxa-zero-dts-add-support-for-the-usb-c-controller.patch"
        "patches/kernel/archive/meson64-6.18/board-radxa-zero-dts-slow-down-sdio-for-working-emmc.patch"
        "patches/kernel/archive/meson64-6.18/board-radxa-zero-dts-slow-down-sdio-for-working-wifi.patch"
        "patches/kernel/archive/meson64-6.18/board-radxa-zero2-arm64-dts-amlogic-Enable-the-npu-node-for-Radxa-Zero2.patch"
        "patches/kernel/archive/meson64-6.18/board-t95z-add-rc-remote-keymap.patch"
        "patches/kernel/archive/meson64-6.18/driver-power-meson64-reset.patch"
        "patches/kernel/archive/meson64-6.18/drv-spi-spidev-remove-warnings.patch"
        "patches/kernel/archive/meson64-6.18/general-add-Amlogic-Meson-GX-PM-Suspend.patch"
        "patches/kernel/archive/meson64-6.18/general-add-overlay-compilation-support.patch"
        "patches/kernel/archive/meson64-6.18/general-driver-tm1628-auxdisplay-add-support-for-Titanmec-TM16.patch"
        "patches/kernel/archive/meson64-6.18/general-drm-dw-hdmi-call-hdmi_set_cts_n-after-clock.patch"
        "patches/kernel/archive/meson64-6.18/general-drm-panfrost-fix-reference-leak.patch"
        "patches/kernel/archive/meson64-6.18/general-fix-Kodi-sysinfo-CPU-information.patch"
        "patches/kernel/archive/meson64-6.18/general-gpu-drm-add-new-display-resolution-2560x1440.patch"
        "patches/kernel/archive/meson64-6.18/general-media-cec-silence-CEC-timeout-message-HACK.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-aiu-Fix-HDMI-codec-control-selection.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-mmc-1-arm64-amlogic-mmc-meson-gx-Add-core-tx-rx-eMMC-SD-SD.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-mmc-2-arm64-amlogic-dts-meson-update-meson-axg-device-tree.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-mmc-3-arm64-dts-docs-Update-mmc-meson-gx-documentation-for.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-vdec-add-HEVC-decode-codec.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-vdec-add-handling-to-HEVC-decoder-.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-vdec-check-if-parser-has-really-parser.patch"
        "patches/kernel/archive/meson64-6.18/general-meson-vdec-improve-mmu-and-fbc-handling-.patch"
        "patches/kernel/archive/meson64-6.18/general-meson64-overlays.patch"
        "patches/kernel/archive/meson64-6.18/general-si2168-fix-cmd-timeout.patch"
        "patches/kernel/archive/meson64-6.18/general-soc-0001-soc-amlogic-meson-gx-socinfo-move-common-code-to-hea.patch"
        "patches/kernel/archive/meson64-6.18/general-soc-0002-soc-amlogic-meson-gx-socinfo-sm-Add-Amlogic-secure-m.patch"
        "patches/kernel/archive/meson64-6.18/general-soc-0003-dt-bindings-arm-amlogic-amlogic-meson-gx-ao-secure-a.patch"
        "patches/kernel/archive/meson64-6.18/general-soc-0004-arm64-dts-meson-add-dts-links-to-secure-monitor-for-.patch"
        "patches/kernel/archive/meson64-6.18/general-sound-soc-remove-mono-channel-as-it-curren.patch"
        "patches/kernel/archive/meson64-6.18/general-spi-nor-add-support-for-XT25F128B.patch"
        "patches/kernel/archive/meson64-6.18/general-usb-core-improve-handling-of-hubs-with-no-ports.patch"
        "patches/kernel/archive/meson64-6.18/hwmon-emc2305-fixups-for-driver.patch"
        "patches/kernel/archive/meson64-6.18/jethome-0001-Fix-meson64-add-gpio-irq-patch-from-https-lkml.org-l.patch"
        "patches/kernel/archive/meson64-6.18/jethome-0002-arm64-dts-jethub-j1xx-add-eeprom-node.patch"
        "patches/kernel/archive/meson64-6.18/kernel-6.8-tools-cgroup-makefile.patch"
        "patches/kernel/archive/meson64-6.18/meson-g12a-pinctrl-add-missing-ir-options.patch"
        "patches/kernel/archive/meson64-6.18/meson-g12a-radxa-zero-gpio-pin-names.patch"
        "patches/kernel/archive/meson64-6.18/meson-g12b-dt-Add-missing-pinmux-node-for-pwm.patch"
        "patches/kernel/archive/meson64-6.18/meson-gx-dts-add-support-for-GX-PM-and-VRTC.patch"
        "patches/kernel/archive/meson64-6.18/meson-gxbb-dts-i2cX-missing-pins.patch"
        "patches/kernel/archive/meson64-6.18/meson-gxbb-vdec-add-HEVC-support-to-GXBB.patch"
        "patches/kernel/archive/meson64-6.18/meson-gxl-gxm-arm64-dts-meson-set-p212-p23x-q20x-SDIO-to-100MH.patch"
        "patches/kernel/archive/meson64-6.18/meson-gxm-vdec-add-VP9-support-to-GXM.patch"
        "patches/kernel/archive/meson64-6.18/meson-sm1-dts-add-higher-clocks.patch"
        "patches/kernel/archive/meson64-6.18/x-PATCH-v7-2-2-PCI-dwc-Remove-redundant-MPS-configuration.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "meson64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2022.07";
      config = "libre_computer_aml_a311d_cc_defconfig";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = "v2022.07";
      patches = [
        "patches/uboot/v2022.07/0001-HACK-configs-meson64-prevent-stdout-stderr-on-videoconsole.patch"
        "patches/uboot/v2022.07/0003-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
        "patches/uboot/v2022.07/board_bananapim5/bananapi-m5-fix-wrong-GPIO-pin-labeling-for-CON1.patch"
        "patches/uboot/v2022.07/board_bananapim5/u-boot-meson64-current.patch"
        "patches/uboot/v2022.07/board_macchiatobin-doubleshot/0001-env_and_10g.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0002-tinkerboard-add-emmc.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0004-make-emmc-bootable.patch"
        "patches/uboot/v2022.07/board_tinkerboard/add-overlay-support.patch"
        "patches/uboot/v2022.07/board_tinkerboard/zzz-usb-otg-fix.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/u-boot-1000-enable-rockchip-efuse-for-rk322x-rk3288-and-rk3328.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-defconfig.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-device-tree.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/zzz-usb-otg-fix.patch"
        "patches/uboot/v2022.07/enable-DT-overlays-support.patch"
        "patches/uboot/v2022.07/general-fix-use-semantic-versioning.patch"
        "patches/uboot/v2022.07/u-boot-meson64-support-old-bootscripts.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = "u-boot-dtb.img;;u-boot.bin.sd.bin:u-boot.bin u-boot-dtb.img";
    };
  };
  "meson64-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-meson64-edge";
      config_path = "config/kernel/linux-meson64-edge.config";
      config_path_nix = "configs/linux-meson64-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-meson64-branch-linux-7-0-y";
      patch_dir = "archive/meson64-7.0";
      patches = [
        "patches/kernel/archive/meson64-7.0/board-bananapi-cm4-cm4io.patch"
        "patches/kernel/archive/meson64-7.0/board-bananapi-m2s.patch"
        "patches/kernel/archive/meson64-7.0/board-bananapim5-001-sd-use-270-mmc-clock-phase-via-dt.patch"
        "patches/kernel/archive/meson64-7.0/board-bananapim5-002-add-wifi-bt-support.patch"
        "patches/kernel/archive/meson64-7.0/board-bananapism1-add-uart_A-and-AO_B.patch"
        "patches/kernel/archive/meson64-7.0/board-khadas-vim3-add-npu-node.patch"
        "patches/kernel/archive/meson64-7.0/board-khadas-vim3-fix-missing-i2c3-nod.patch"
        "patches/kernel/archive/meson64-7.0/board-khadas-vims-add-rtc-vrtc-aliases.patch"
        "patches/kernel/archive/meson64-7.0/board-nanopi-k2-add-uartC-alias.patch"
        "patches/kernel/archive/meson64-7.0/board-nanopi-k2-enable-emmc.patch"
        "patches/kernel/archive/meson64-7.0/board-odroid-sm1-reset.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidc2-add-uartA-uartC.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidc2-enable-SPI.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidc2-enable-scpi-dvfs.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidc2-usb-hub-disable-autosuspend-for-Genesys-Logic-.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidhc4-enable-fan1_input.patch"
        "patches/kernel/archive/meson64-7.0/board-odroidn2plus-Add-missing-CPU-opp.patch"
        "patches/kernel/archive/meson64-7.0/board-radxa-zero-dts-add-aliases-for-serial-i2c-and-spi.patch"
        "patches/kernel/archive/meson64-7.0/board-radxa-zero-dts-add-support-for-the-usb-c-controller.patch"
        "patches/kernel/archive/meson64-7.0/board-radxa-zero-dts-slow-down-sdio-for-working-emmc.patch"
        "patches/kernel/archive/meson64-7.0/board-radxa-zero-dts-slow-down-sdio-for-working-wifi.patch"
        "patches/kernel/archive/meson64-7.0/board-radxa-zero2-arm64-dts-amlogic-Enable-the-npu-node-for-Radxa-Zero2.patch"
        "patches/kernel/archive/meson64-7.0/board-t95z-add-rc-remote-keymap.patch"
        "patches/kernel/archive/meson64-7.0/driver-power-meson64-reset.patch"
        "patches/kernel/archive/meson64-7.0/drv-spi-spidev-remove-warnings.patch"
        "patches/kernel/archive/meson64-7.0/general-add-Amlogic-Meson-GX-PM-Suspend.patch"
        "patches/kernel/archive/meson64-7.0/general-add-overlay-compilation-support.patch"
        "patches/kernel/archive/meson64-7.0/general-driver-tm1628-auxdisplay-add-support-for-Titanmec-TM16.patch"
        "patches/kernel/archive/meson64-7.0/general-drm-dw-hdmi-call-hdmi_set_cts_n-after-clock.patch"
        "patches/kernel/archive/meson64-7.0/general-fix-Kodi-sysinfo-CPU-information.patch"
        "patches/kernel/archive/meson64-7.0/general-media-cec-silence-CEC-timeout-message-HACK.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-aiu-Fix-HDMI-codec-control-selection.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-mmc-1-arm64-amlogic-mmc-meson-gx-Add-core-tx-rx-eMMC-SD-SD.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-mmc-2-arm64-amlogic-dts-meson-update-meson-axg-device-tree.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-mmc-3-arm64-dts-docs-Update-mmc-meson-gx-documentation-for.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-vdec-add-HEVC-decode-codec.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-vdec-add-handling-to-HEVC-decoder-.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-vdec-check-if-parser-has-really-parser.patch"
        "patches/kernel/archive/meson64-7.0/general-meson-vdec-improve-mmu-and-fbc-handling-.patch"
        "patches/kernel/archive/meson64-7.0/general-meson64-overlays.patch"
        "patches/kernel/archive/meson64-7.0/general-si2168-fix-cmd-timeout.patch"
        "patches/kernel/archive/meson64-7.0/general-soc-0001-soc-amlogic-meson-gx-socinfo-move-common-code-to-hea.patch"
        "patches/kernel/archive/meson64-7.0/general-soc-0002-soc-amlogic-meson-gx-socinfo-sm-Add-Amlogic-secure-m.patch"
        "patches/kernel/archive/meson64-7.0/general-soc-0003-dt-bindings-arm-amlogic-amlogic-meson-gx-ao-secure-a.patch"
        "patches/kernel/archive/meson64-7.0/general-soc-0004-arm64-dts-meson-add-dts-links-to-secure-monitor-for-.patch"
        "patches/kernel/archive/meson64-7.0/general-sound-soc-remove-mono-channel-as-it-curren.patch"
        "patches/kernel/archive/meson64-7.0/general-spi-nor-add-support-for-XT25F128B.patch"
        "patches/kernel/archive/meson64-7.0/general-usb-core-improve-handling-of-hubs-with-no-ports.patch"
        "patches/kernel/archive/meson64-7.0/hwmon-emc2305-fixups-for-driver.patch"
        "patches/kernel/archive/meson64-7.0/jethome-0001-Fix-meson64-add-gpio-irq-patch-from-https-lkml.org-l.patch"
        "patches/kernel/archive/meson64-7.0/jethome-0002-arm64-dts-jethub-j1xx-add-eeprom-node.patch"
        "patches/kernel/archive/meson64-7.0/jethome-0003-arm64-dts-meson-add-dts-links-to-secure-monitor-for-jethub.patch"
        "patches/kernel/archive/meson64-7.0/kernel-6.8-tools-cgroup-makefile.patch"
        "patches/kernel/archive/meson64-7.0/meson-g12a-pinctrl-add-missing-ir-options.patch"
        "patches/kernel/archive/meson64-7.0/meson-g12a-radxa-zero-gpio-pin-names.patch"
        "patches/kernel/archive/meson64-7.0/meson-g12b-dt-Add-missing-pinmux-node-for-pwm.patch"
        "patches/kernel/archive/meson64-7.0/meson-gx-dts-add-support-for-GX-PM-and-VRTC.patch"
        "patches/kernel/archive/meson64-7.0/meson-gxbb-dts-i2cX-missing-pins.patch"
        "patches/kernel/archive/meson64-7.0/meson-gxbb-vdec-add-HEVC-support-to-GXBB.patch"
        "patches/kernel/archive/meson64-7.0/meson-gxl-gxm-arm64-dts-meson-set-p212-p23x-q20x-SDIO-to-100MH.patch"
        "patches/kernel/archive/meson64-7.0/meson-gxm-vdec-add-VP9-support-to-GXM.patch"
        "patches/kernel/archive/meson64-7.0/meson-sm1-dts-add-higher-clocks.patch"
        "patches/kernel/archive/meson64-7.0/x-PATCH-v7-2-2-PCI-dwc-Remove-redundant-MPS-configuration.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "meson64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2022.07";
      config = "libre_computer_aml_a311d_cc_defconfig";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = "v2022.07";
      patches = [
        "patches/uboot/v2022.07/0001-HACK-configs-meson64-prevent-stdout-stderr-on-videoconsole.patch"
        "patches/uboot/v2022.07/0003-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
        "patches/uboot/v2022.07/board_bananapim5/bananapi-m5-fix-wrong-GPIO-pin-labeling-for-CON1.patch"
        "patches/uboot/v2022.07/board_bananapim5/u-boot-meson64-current.patch"
        "patches/uboot/v2022.07/board_macchiatobin-doubleshot/0001-env_and_10g.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0001-tinkerboard-defconfig-fix.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0002-tinkerboard-add-emmc.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0003-UMS-mode-on-otg-port.patch"
        "patches/uboot/v2022.07/board_tinkerboard/0004-make-emmc-bootable.patch"
        "patches/uboot/v2022.07/board_tinkerboard/add-overlay-support.patch"
        "patches/uboot/v2022.07/board_tinkerboard/zzz-usb-otg-fix.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/u-boot-1000-enable-rockchip-efuse-for-rk322x-rk3288-and-rk3328.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-defconfig.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-device-tree-makefile.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/xt-q8l-v10-device-tree.patch"
        "patches/uboot/v2022.07/board_xt-q8l-v10/zzz-usb-otg-fix.patch"
        "patches/uboot/v2022.07/enable-DT-overlays-support.patch"
        "patches/uboot/v2022.07/general-fix-use-semantic-versioning.patch"
        "patches/uboot/v2022.07/u-boot-meson64-support-old-bootscripts.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = "u-boot-dtb.img;;u-boot.bin.sd.bin:u-boot.bin u-boot-dtb.img";
    };
  };
}
