{
  "sm8550-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-sm8550-current";
      config_path = "config/kernel/linux-sm8550-current.config";
      config_path_nix = "configs/linux-sm8550-current.config";
      exact_version = "6.18.38";
      hash = "sha256-S48YwJ0smqgblFkpCXNOIY3gRpsmEb8KubAlRjFxBV0=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-sm8550-branch-linux-6-18-y";
      patch_dir = "archive/sm8550-6.18";
      patches = [
        "patches/kernel/archive/sm8550-6.18/0001-msm-adreno-enable-A32.patch"
        "patches/kernel/archive/sm8550-6.18/0002-qcom-dispcc-sm8550-Fix-disp_cc_mdss_mdp_clk_src.patch"
        "patches/kernel/archive/sm8550-6.18/0030-input-rmi4-add-reset-gpio.patch"
        "patches/kernel/archive/sm8550-6.18/0031_input--Add-driver-for-RSInput-Gamepad.patch"
        "patches/kernel/archive/sm8550-6.18/0033_leds--Add-driver-for-HEROIC-HTR3212.patch"
        "patches/kernel/archive/sm8550-6.18/0036_ASoC--qcom--sc8280xp-Add-support-for-Primary-I2S.patch"
        "patches/kernel/archive/sm8550-6.18/0042_mmc--sdhci-msm--Toggle-the-FIFO-write-clock-after-.patch"
        "patches/kernel/archive/sm8550-6.18/0047_ASoC--codecs--aw88166--AYN-Odin2-Specific-modifica.patch"
        "patches/kernel/archive/sm8550-6.18/0050_pmk8550-pwm.patch"
        "patches/kernel/archive/sm8550-6.18/0051-gpu-panel-add-Pocket-ACE-panel-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0052-gpu-panel-add-Pocket-DMG-panel-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0052_qcom-downstream-sdhci-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0053-add-hynitron-touchscreen.patch"
        "patches/kernel/archive/sm8550-6.18/0053-battery-name.patch"
        "patches/kernel/archive/sm8550-6.18/0053-edt-ft5x06-add-no_regmap_bulk_read-option.patch"
        "patches/kernel/archive/sm8550-6.18/0053-gpu-panel-add-Pocket-DS-lower-panel-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0054_sn3112-pwm-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0055_Synaptics-TD4328-LCD-panel.patch"
        "patches/kernel/archive/sm8550-6.18/0056_Xm-Plus-XM91080G-panel.patch"
        "patches/kernel/archive/sm8550-6.18/0057_Chipone-ICNA35XX-panel.patch"
        "patches/kernel/archive/sm8550-6.18/0057_DDIC-CH13726A-panel.patch"
        "patches/kernel/archive/sm8550-6.18/0058_AYN-Odin2-Mini--backlight.patch"
        "patches/kernel/archive/sm8550-6.18/0059_AYN-Odin2-Mini--hynitron--cstxxx.patch"
        "patches/kernel/archive/sm8550-6.18/0060-Add-Silergy-SY7758-backlight-driver.patch"
        "patches/kernel/archive/sm8550-6.18/0061-regulator-add-sgm3804-i2c-regulator-for-panel-power-.patch"
        "patches/kernel/archive/sm8550-6.18/0062_rsinput--regulator.patch"
        "patches/kernel/archive/sm8550-6.18/0070-drm-msm-remove-DRIVER_SYNCOBJ_TIMELINE.patch"
        "patches/kernel/archive/sm8550-6.18/0071-HACK-fix-usb-boot-hang.patch"
        "patches/kernel/archive/sm8550-6.18/0100-SM8550-Fix-L2-cache-for-CPU2-and-add-cache-sizes.patch"
        "patches/kernel/archive/sm8550-6.18/0101-SM8550-Add-DDR-LLCC-L3-CPU-bandwidth-scaling.patch"
        "patches/kernel/archive/sm8550-6.18/0102-20240424_wuxilin123_ayn_odin_2_support.patch"
        "patches/kernel/archive/sm8550-6.18/0103_arm64--dts--qcom--sm8550--add-UART15.patch"
        "patches/kernel/archive/sm8550-6.18/0104-drm-panel-Add-Retroid-Pocket-6-panel.patch"
        "patches/kernel/archive/sm8550-6.18/0120-20250728_konradybcio_gpu_cc_power_requirements_reality_check.patch"
        "patches/kernel/archive/sm8550-6.18/0122-interconnect__qcom__sm8550__Enable_QoS_configuration.patch"
        "patches/kernel/archive/sm8550-6.18/0154-dts-qcom-sm8550-add-opp-acd-level.patch"
        "patches/kernel/archive/sm8550-6.18/0200_arm64--dts--qcom--Add-AYN-QCS8550-Common.patch"
        "patches/kernel/archive/sm8550-6.18/0201_arm64--dts--qcom--Add-AYN-Odin2.patch"
        "patches/kernel/archive/sm8550-6.18/0202_arm64--dts--qcom--Add-AYN-Odin2-Mini.patch"
        "patches/kernel/archive/sm8550-6.18/0203_arm64--dts--qcom--Add-AYN-Odin2-Portal.patch"
        "patches/kernel/archive/sm8550-6.18/0204_arm64--dts--qcom--Add-AYN-Thor.patch"
        "patches/kernel/archive/sm8550-6.18/0210_arm64--dts--qcom--Add-AYANEO-Pocket-Common.patch"
        "patches/kernel/archive/sm8550-6.18/0211_arm64--dts--qcom--Add-AYANEO-Pocket-ACE.patch"
        "patches/kernel/archive/sm8550-6.18/0212_arm64--dts--qcom--Add-AYANEO-Pocket-DMG.patch"
        "patches/kernel/archive/sm8550-6.18/0213_arm64--dts--qcom--Add-AYANEO-Pocket-EVO.patch"
        "patches/kernel/archive/sm8550-6.18/0214_arm64--dts--qcom--Add-AYANEO-Pocket-DS.patch"
        "patches/kernel/archive/sm8550-6.18/0500-ROCKNIX-set-boot-fanspeed.patch"
        "patches/kernel/archive/sm8550-6.18/0501-ROCKNIX-fix-wifi-and-bt-mac.patch"
        "patches/kernel/archive/sm8550-6.18/0503-ROCKNIX-battery-name.patch"
        "patches/kernel/archive/sm8550-6.18/9999-allow-aarch64-to-perform-32bit-syscalls.patch"
        "patches/kernel/archive/sm8550-6.18/v5_20251120_quic_utiwari_crypto_qce_add_runtime_pm_and_interconnect_bandwidth_scaling_support.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "sm8550";
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
  "sm8550-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-sm8550-edge";
      config_path = "config/kernel/linux-sm8550-edge.config";
      config_path_nix = "configs/linux-sm8550-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-sm8550-branch-linux-7-0-y";
      patch_dir = "archive/sm8550-7.0";
      patches = [
        "patches/kernel/archive/sm8550-7.0/0001-msm-adreno-enable-A32.patch"
        "patches/kernel/archive/sm8550-7.0/0002-qcom-dispcc-sm8550-Fix-disp_cc_mdss_mdp_clk_src.patch"
        "patches/kernel/archive/sm8550-7.0/0003-input-rmi4-add-reset-gpio.patch"
        "patches/kernel/archive/sm8550-7.0/0004-input-Add-driver-for-RSInput-Gamepad.patch"
        "patches/kernel/archive/sm8550-7.0/0005-leds-Add-driver-for-HEROIC-HTR3212.patch"
        "patches/kernel/archive/sm8550-7.0/0006-ASoC-qcom-sc8280xp-Add-support-for-Primary-and-Secon.patch"
        "patches/kernel/archive/sm8550-7.0/0007-mmc-sdhci-msm-Toggle-the-FIFO-write-clock-after-unga.patch"
        "patches/kernel/archive/sm8550-7.0/0008-ASoC-codecs-aw88166-AYN-Products-Specific-modificati.patch"
        "patches/kernel/archive/sm8550-7.0/0009-arm64-dts-qcom-Added-pmk8550_pwm.patch"
        "patches/kernel/archive/sm8550-7.0/0010-gpu-panel-add-Pocket-ACE-panel-driver.patch"
        "patches/kernel/archive/sm8550-7.0/0011-input-touchscreen-porting-downstream-hynitron-driver.patch"
        "patches/kernel/archive/sm8550-7.0/0012-qcom_battmgr-Set-battery-name.patch"
        "patches/kernel/archive/sm8550-7.0/0013-Input-edt-ft5x06-add-no_regmap_bulk_read-option.patch"
        "patches/kernel/archive/sm8550-7.0/0014-pwm-Add-SI-EN-SN3112-PWM-support.patch"
        "patches/kernel/archive/sm8550-7.0/0015-drm-panel-Add-WIP-panel-driver-for-AYN-Odin-2.patch"
        "patches/kernel/archive/sm8550-7.0/0016-drm-panel-Add-panel-driver-for-Xm-Plus-XM91080G-base.patch"
        "patches/kernel/archive/sm8550-7.0/0017-drm-panel-Add-panel-driver-for-Chipone-ICNA35XX-base.patch"
        "patches/kernel/archive/sm8550-7.0/0018-drm-panel-Add-panel-driver-for-DDIC-CH13726A-based-p.patch"
        "patches/kernel/archive/sm8550-7.0/0019-backlight-odin2mini-backlight-Add-support-for-AYN-Od.patch"
        "patches/kernel/archive/sm8550-7.0/0020-Input-hynitron_cstxxx-specific-patch-for-Odin2-Mini.patch"
        "patches/kernel/archive/sm8550-7.0/0021-Add-Silergy-SY7758-backlight-driver.patch"
        "patches/kernel/archive/sm8550-7.0/0022-regulator-add-sgm3804-i2c-regulator-for-panel-power-.patch"
        "patches/kernel/archive/sm8550-7.0/0023-input-RSInput-Add-regulator.patch"
        "patches/kernel/archive/sm8550-7.0/0024-drm-msm-remove-DRIVER_SYNCOBJ_TIMELINE.patch"
        "patches/kernel/archive/sm8550-7.0/0025-HACK-fix-usb-boot-hang.patch"
        "patches/kernel/archive/sm8550-7.0/0026-SM8550-Fix-L2-cache-for-CPU2-and-add-cache-sizes.patch"
        "patches/kernel/archive/sm8550-7.0/0027-SM8550-Add-DDR-LLCC-L3-CPU-bandwidth-scaling.patch"
        "patches/kernel/archive/sm8550-7.0/0028-arm64-dts-qcom-sm8550-Update-EAS-properties.patch"
        "patches/kernel/archive/sm8550-7.0/0029-arm64-dts-qcom-sm8550-add-UART15.patch"
        "patches/kernel/archive/sm8550-7.0/0030-drm-panel-Add-Retroid-Pocket-6-panel.patch"
        "patches/kernel/archive/sm8550-7.0/0031-arm64-dts-qcom-sm8550-Describe-GPU_CC-power-plumbing.patch"
        "patches/kernel/archive/sm8550-7.0/0032-interconnect-qcom-sm8550-Enable-QoS-configuration.patch"
        "patches/kernel/archive/sm8550-7.0/0033-dts-qcom-sm8550-add-opp-acd-level.patch"
        "patches/kernel/archive/sm8550-7.0/0034-arm64-dts-qcom-Add-AYN-QCS8550-Common.patch"
        "patches/kernel/archive/sm8550-7.0/0035-arm64-dts-qcom-Add-AYN-Odin2.patch"
        "patches/kernel/archive/sm8550-7.0/0036-arm64-dts-qcom-Add-AYN-Odin2-Mini.patch"
        "patches/kernel/archive/sm8550-7.0/0037-arm64-dts-qcom-Add-AYN-Odin2-Portal.patch"
        "patches/kernel/archive/sm8550-7.0/0038-arm64-dts-qcom-Add-AYN-Thor.patch"
        "patches/kernel/archive/sm8550-7.0/0039-ROCKNIX-set-boot-fanspeed.patch"
        "patches/kernel/archive/sm8550-7.0/0040-drivers-use-soc-serial-for-wifi-and-bluetooth.patch"
        "patches/kernel/archive/sm8550-7.0/0041-power-supply-rename-qcom-battmgr-sysfs.patch"
        "patches/kernel/archive/sm8550-7.0/0042-Enable-64-bit-processes-to-use-compat-input-syscalls.patch"
        "patches/kernel/archive/sm8550-7.0/0049-crypto-qce-Add-runtime-PM-and-interconnect-bandwidth.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "sm8550";
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
