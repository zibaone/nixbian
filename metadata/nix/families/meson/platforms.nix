{
  "meson-current" = {
    arch = "armhf";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "tag:v6.12.28";
      config = "linux-meson-current";
      config_path = "config/kernel/linux-meson-current.config";
      config_path_nix = "configs/linux-meson-current.config";
      exact_version = "6.12.28";
      hash = "sha256-xU1lzXgsUMsICyTVWx84LLSCae3DvWpv5wjYmtkIsLs=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-meson-tag-v6-12-28";
      patch_dir = "archive/meson-6.12";
      patches = [
        "patches/kernel/archive/meson-6.12/0007-dt-bindings-phy-meson8b-usb2-Add-support-for-reading.patch"
        "patches/kernel/archive/meson-6.12/0008-phy-amlogic-meson8b-usb2-Add-support-for-reading-the.patch"
        "patches/kernel/archive/meson-6.12/0009-usb-common-usb-conn-gpio-Fall-back-to-polling-the-GP.patch"
        "patches/kernel/archive/meson-6.12/0010-usb-dwc2-register-child-USB-connector-devices.patch"
        "patches/kernel/archive/meson-6.12/0011-ARM-dts-meson-Add-GPIO-controller-capabilities-to-th.patch"
        "patches/kernel/archive/meson-6.12/0012-ARM-dts-meson8b-odroidc1-Enable-the-Micro-USB-OTG-co.patch"
        "patches/kernel/archive/meson-6.12/0013-dt-bindings-phy-Add-bindings-for-the-Amlogic-Meson-C.patch"
        "patches/kernel/archive/meson-6.12/0014-phy-amlogic-Add-a-new-driver-for-the-CVBS-DAC-CVBS-P.patch"
        "patches/kernel/archive/meson-6.12/0015-dt-bindings-display-meson-vpu-Add-the-CVBS-DAC-prope.patch"
        "patches/kernel/archive/meson-6.12/0016-drm-meson-Add-support-for-using-a-PHY-for-the-CVBS-D.patch"
        "patches/kernel/archive/meson-6.12/0018-dt-bindings-clock-meson8b-Add-the-RMII-reference-clo.patch"
        "patches/kernel/archive/meson-6.12/0019-dt-bindings-clock-meson8b-Add-the-Meson8-Ethernet-RM.patch"
        "patches/kernel/archive/meson-6.12/0020-clk-meson-meson8b-Add-the-Ethernet-RMII-clock-tree-o.patch"
        "patches/kernel/archive/meson-6.12/0021-dt-bindings-net-dwmac-meson-Add-the-Ethernet-clock-i.patch"
        "patches/kernel/archive/meson-6.12/0022-net-stmmac-dwmac-meson-Rename-the-SPEED_100-macro.patch"
        "patches/kernel/archive/meson-6.12/0023-net-stmmac-dwmac-meson-Manage-the-ethernet-clock.patch"
        "patches/kernel/archive/meson-6.12/0024-net-stmmac-dwmac-meson-Initialize-all-known-PREG_ETH.patch"
        "patches/kernel/archive/meson-6.12/0025-ARM-dts-meson-meson8-Add-the-clock-input-to-the-Ethe.patch"
        "patches/kernel/archive/meson-6.12/0026-dt-bindings-clock-meson8b-add-the-rtc_32k-oscillator.patch"
        "patches/kernel/archive/meson-6.12/0027-clk-meson-meson8b-Add-the-mpeg_rtc_osc_sel-clock.patch"
        "patches/kernel/archive/meson-6.12/0028-ARM-dts-meson-Add-address-cells-size-cells-and-range.patch"
        "patches/kernel/archive/meson-6.12/0029-dt-bindings-firmware-Document-the-Amlogic-Meson6-8-8.patch"
        "patches/kernel/archive/meson-6.12/0030-dt-bindings-arm-cpus-Document-Meson8-TrustZone-firmw.patch"
        "patches/kernel/archive/meson-6.12/0031-ARM-meson-Add-support-for-the-TrustZone-firmware.patch"
        "patches/kernel/archive/meson-6.12/0032-ARM-meson-platsmp-Add-support-for-SoCs-running-on-Tr.patch"
        "patches/kernel/archive/meson-6.12/0033-soc-amlogic-meson-mx-socinfo-Add-support-for-the-Tru.patch"
        "patches/kernel/archive/meson-6.12/0034-nvmem-meson-mx-efuse-Add-support-for-the-TrustZone-f.patch"
        "patches/kernel/archive/meson-6.12/0036-ARM-dts-meson8-Add-the-PWM_C-DV9-and-PWM_D-pins.patch"
        "patches/kernel/archive/meson-6.12/0045-dt-bindings-display-meson-vpu-add-support-for-Meson8.patch"
        "patches/kernel/archive/meson-6.12/0046-drm-meson-add-Meson8-Meson8b-Meson8m2-specific-vpu_c.patch"
        "patches/kernel/archive/meson-6.12/0047-drm-meson-Use-24-bits-per-pixel-for-the-framebuffer-.patch"
        "patches/kernel/archive/meson-6.12/0048-drm-meson-Use-a-separate-list-of-supported-formats-f.patch"
        "patches/kernel/archive/meson-6.12/0049-drm-meson-Skip-VIU_OSD1_CTRL_STAT2-alpha-replace-val.patch"
        "patches/kernel/archive/meson-6.12/0050-drm-meson-Enable-the-RGB-to-YUV-converter-on-Meson8-.patch"
        "patches/kernel/archive/meson-6.12/0051-drm-meson-Update-meson_vpu_init-to-work-with-Meson8-.patch"
        "patches/kernel/archive/meson-6.12/0052-drm-meson-Describe-the-HDMI-PHY-frequency-limits-of-.patch"
        "patches/kernel/archive/meson-6.12/0053-drm-meson-Update-the-HDMI-encoder-for-Meson8-8b-8m2.patch"
        "patches/kernel/archive/meson-6.12/0054-drm-meson-Only-set-ycbcr_420_allowed-on-64-bit-SoCs.patch"
        "patches/kernel/archive/meson-6.12/0055-drm-meson-Make-the-HHI-registers-optional-WIP.patch"
        "patches/kernel/archive/meson-6.12/0056-drm-meson-Add-support-for-the-Meson8-8b-8m2-TranSwit.patch"
        "patches/kernel/archive/meson-6.12/0057-drm-meson-Meson8-Meson8b-Meson8m2-VCLK-HACK.patch"
        "patches/kernel/archive/meson-6.12/0058-drm-meson-Enable-support-for-Meson8-Meson8b-Meson8m2.patch"
        "patches/kernel/archive/meson-6.12/0059-ARM-dts-meson-add-the-VPU-WiP.patch"
        "patches/kernel/archive/meson-6.12/0060-ARM-dts-meson8-add-the-HDMI-controller-WiP.patch"
        "patches/kernel/archive/meson-6.12/0061-ARM-dts-meson8-Add-the-shared-CMA-dma-memory-pool.patch"
        "patches/kernel/archive/meson-6.12/0062-ARM-dts-meson8-add-the-AO-CEC-controller-WiP.patch"
        "patches/kernel/archive/meson-6.12/0063-ARM-dts-meson8b-add-the-HDMI-controller-WiP.patch"
        "patches/kernel/archive/meson-6.12/0064-ARM-dts-meson8b-add-the-AO-CEC-controller-WiP.patch"
        "patches/kernel/archive/meson-6.12/0066-ARM-dts-meson8b-odroid-c1-enable-HDMI-for-the-Odroid.patch"
        "patches/kernel/archive/meson-6.12/0067-meson8b-mxq-add-HDMI-support.patch"
        "patches/kernel/archive/meson-6.12/generic-Revert-pwm-meson-modify-and-simplify-calculation-in-.patch"
        "patches/kernel/archive/meson-6.12/onecloud-0001-add-dts.patch"
        "patches/kernel/archive/meson-6.12/onecloud-0002-dts-Support-HDMI.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "meson";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2022.07";
      config = "none";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = null;
      patches = null;
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = null;
    };
  };
}
