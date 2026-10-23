{
  "sm8250-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-sm8250-current";
      config_path = "config/kernel/linux-sm8250-current.config";
      config_path_nix = "configs/linux-sm8250-current.config";
      exact_version = "6.18.38";
      hash = "sha256-S48YwJ0smqgblFkpCXNOIY3gRpsmEb8KubAlRjFxBV0=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-sm8250-branch-linux-6-18-y";
      patch_dir = "archive/sm8250-6.18";
      patches = [
        "patches/kernel/archive/sm8250-6.18/0001-drm-Add-drm-notifier-support.patch"
        "patches/kernel/archive/sm8250-6.18/0002-drm-dsi-emit-panel-turn-on-off-signal-to-touchscreen.patch"
        "patches/kernel/archive/sm8250-6.18/0003-Input-Add-nt36523-touchscreen-driver.patch"
        "patches/kernel/archive/sm8250-6.18/0004-arm64-dts-qcom-sm8250-xiaomi-elish-enable-touchscree.patch"
        "patches/kernel/archive/sm8250-6.18/0005-ASoC-qcom-sm8250-Add-tdm-support.patch"
        "patches/kernel/archive/sm8250-6.18/0006-arm64-dts-qcom-sm8250-xiaomi-elish-Add-sound-support.patch"
        "patches/kernel/archive/sm8250-6.18/0007-Asoc-wm_adsp-Add-prefix-support.patch"
        "patches/kernel/archive/sm8250-6.18/0008-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-Add-dev.patch"
        "patches/kernel/archive/sm8250-6.18/0009-drm-msm-dsi-change-sync-mode-to-sync-on-DSI0-rather-.patch"
        "patches/kernel/archive/sm8250-6.18/0010-arm64-dts-qcom-sm8250-xiaomi-elish-add-keyboard-supp.patch"
        "patches/kernel/archive/sm8250-6.18/0011-arm64-dts-qcom-sm8250-oneplus-kebab-Add-device-tree-.patch"
        "patches/kernel/archive/sm8250-6.18/0012-arm64-dts-qcom-sm8250-xiaomi-elish-remove-framebuffe.patch"
        "patches/kernel/archive/sm8250-6.18/0013-input-nt36xxx-Enable-pen-support.patch"
        "patches/kernel/archive/sm8250-6.18/0014-nt36xxx-add-pen-input-resolution.patch"
        "patches/kernel/archive/sm8250-6.18/0015-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-Restore.patch"
        "patches/kernel/archive/sm8250-6.18/0016-drm-panel-Add-panel-driver-for-samsung-amsa26zp01.patch"
        "patches/kernel/archive/sm8250-6.18/0017-ASoC-cs35l45-disable-power-managerment.patch"
        "patches/kernel/archive/sm8250-6.18/0018-ASoC-cs35l45-Add-ASPRX-1-2-Slot-Position.patch"
        "patches/kernel/archive/sm8250-6.18/0019-ASoC-qcom-sm8250-Add-primary-tdm-support.patch"
        "patches/kernel/archive/sm8250-6.18/0020-arm64-dts-qcom-add-device-tree-for-Xiaoxin-Pad-Pro-1.patch"
        "patches/kernel/archive/sm8250-6.18/0021-power-supply-add-bq25970-charger-driver.patch"
        "patches/kernel/archive/sm8250-6.18/0022-arm64-dts-qcom-sm8250-xiaomi-elish-add-bq25970-charg.patch"
        "patches/kernel/archive/sm8250-6.18/0023-arm64-dts-qcom-sm8250-xiaomi-elish-add-flash-led-nod.patch"
        "patches/kernel/archive/sm8250-6.18/0024-power-supply-Add-driver-for-Qualcomm-PMIC-fuel-gauge.patch"
        "patches/kernel/archive/sm8250-6.18/0025-power-qcom_fg-Add-initial-pm8150b-support.patch"
        "patches/kernel/archive/sm8250-6.18/0026-qcom_fg-Fix-compilation-in-6.11.patch"
        "patches/kernel/archive/sm8250-6.18/0027-arm64-dts-qcom-pm8150b-Add-fuel-gauge.patch"
        "patches/kernel/archive/sm8250-6.18/0028-From-Teguh-Sobirin-teguh-sobir.in-Date-Sun-24-Nov-20.patch"
        "patches/kernel/archive/sm8250-6.18/0029-From-Teguh-Sobirin-teguh-sobir.in-Date-Wed-20-Nov-20.patch"
        "patches/kernel/archive/sm8250-6.18/0030-power-supply-qcom_fg-invert-charging-current.patch"
        "patches/kernel/archive/sm8250-6.18/0031-arm64-dts-qcom-sm8250-xiaomi-elish-add-pm8150b-charg.patch"
        "patches/kernel/archive/sm8250-6.18/0032-drm-panel-samsung-amsa26zp01-backlight-add-Smooth-di.patch"
        "patches/kernel/archive/sm8250-6.18/0033-Revert-ASoC-cs35l45-disable-power-managerment.patch"
        "patches/kernel/archive/sm8250-6.18/0034-arm64-dts-qcom-sm8250-lenovo-q706f-clean-up-devicetr.patch"
        "patches/kernel/archive/sm8250-6.18/0035-arm64-dts-qcom-sm8250-lenovo-q706f-Add-hall-sensor-f.patch"
        "patches/kernel/archive/sm8250-6.18/0036-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-swtich-.patch"
        "patches/kernel/archive/sm8250-6.18/0037-power-supply-qcom_pm8150b_charger-adds-charging-cont.patch"
        "patches/kernel/archive/sm8250-6.18/0038-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-adds-us.patch"
        "patches/kernel/archive/sm8250-6.18/0039-power-supply-qcom_pm8150b_charger-clean-up.patch"
        "patches/kernel/archive/sm8250-6.18/0040-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-add-mis.patch"
        "patches/kernel/archive/sm8250-6.18/0041-power-supply-qcom_pm8150b_charger-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.18/0042-power-supply-qcom_fg-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.18/0043-power-supply-bq25970_charger-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.18/0044-arm64-dts-qcom-sm8250-xiaomi-elish-set-9V3A-charging.patch"
        "patches/kernel/archive/sm8250-6.18/0045-arm64-dts-qcom-sm8250-add-refgen-regulator-and-use-i.patch"
        "patches/kernel/archive/sm8250-6.18/0046-arm64-dts-qcom-sm8250-Add-MDSS_CORE-reset-to-mdss.patch"
        "patches/kernel/archive/sm8250-6.18/0047-arm64-dts-qcom-sm8250-xiaomi-elish-add-sleep-pinctrl.patch"
        "patches/kernel/archive/sm8250-6.18/0048-arm64-dts-qcom-sm8250-xiaomi-elish-fix-wlan-default-.patch"
        "patches/kernel/archive/sm8250-6.18/0049-arm64-dts-qcom-sm8250-xiaomi-elish-add-enable-and-sw.patch"
        "patches/kernel/archive/sm8250-6.18/0050-arm64-dts-qcom-sm8250-xiaomi-elish-add-BT-swctrl-gpi.patch"
        "patches/kernel/archive/sm8250-6.18/0052-arm64-dts-qcom-sm8250-Add-device-tree-for-Xiaomi-Mi-.patch"
        "patches/kernel/archive/sm8250-6.18/0053-arm64-dts-qcom-sm8250-xiaomi-enuma-enable-PCIe2-node.patch"
        "patches/kernel/archive/sm8250-6.18/0054-arm64-dts-qcom-sm8250-xiaomi-elish-add-label-to-WiFi.patch"
        "patches/kernel/archive/sm8250-6.18/0055-arm64-dts-qcom-sm8250-xiaomi-enuma-use-own-WLAN-cali.patch"
        "patches/kernel/archive/sm8250-6.18/0056-arm64-dts-qcom-sm8250-remote-heap-CMA-for-ADSP-CDSP-.patch"
        "patches/kernel/archive/sm8250-6.18/0057-arm64-dts-qcom-sm8250-add-external-modem-s-AP-MDM-pi.patch"
        "patches/kernel/archive/sm8250-6.18/0058-arm64-dts-qcom-sm8250-xiaomi-elish-add-reset-pin-set.patch"
        "patches/kernel/archive/sm8250-6.18/0059-arm64-dts-qcom-sm8250-xiaomi-elish-add-pin-setting-f.patch"
        "patches/kernel/archive/sm8250-6.18/0060-arm64-dts-qcom-sm8250-xiaomi-elish-add-hall-key.patch"
        "patches/kernel/archive/sm8250-6.18/0061-Revert-misc-fastrpc-Rename-tgid-and-pid-to-client_id.patch"
        "patches/kernel/archive/sm8250-6.18/0062-Revert-misc-fastrpc-Add-support-for-multiple-PD-from.patch"
        "patches/kernel/archive/sm8250-6.18/0064-arm64-dts-qcom-sm8250-add-uart16-Signed-off-by-Teguh.patch"
        "patches/kernel/archive/sm8250-6.18/0065-drm-panel-Add-DDIC-CH13726A-panel-Signed-off-by-Tegu.patch"
        "patches/kernel/archive/sm8250-6.18/0066-leds-Add-driver-for-HEROIC-HTR3212-Signed-off-by-Teg.patch"
        "patches/kernel/archive/sm8250-6.18/0067-Input-driver-for-AYN-Odin2-Gamepad.patch"
        "patches/kernel/archive/sm8250-6.18/0068-input-add-Qualcomm-SPMI-haptics-driver.patch"
        "patches/kernel/archive/sm8250-6.18/0069-arm64-dts-qcom-pm8150b-introduce-spmi-haptics.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "sm8250";
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
  "sm8250-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.19.y";
      config = "linux-sm8250-edge";
      config_path = "config/kernel/linux-sm8250-edge.config";
      config_path_nix = "configs/linux-sm8250-edge.config";
      exact_version = "6.19.14";
      hash = "sha256-yrKwMcqFpDP4oiNsiyFtYKMJmmKhf/J9MPUL1S+0UDg=";
      major_minor = "6.19";
      nvfetcher_key = "kernel-sm8250-branch-linux-6-19-y";
      patch_dir = "archive/sm8250-6.19";
      patches = [
        "patches/kernel/archive/sm8250-6.19/0001-drm-Add-drm-notifier-support.patch"
        "patches/kernel/archive/sm8250-6.19/0002-drm-dsi-emit-panel-turn-on-off-signal-to-touchscreen.patch"
        "patches/kernel/archive/sm8250-6.19/0003-Input-Add-nt36523-touchscreen-driver.patch"
        "patches/kernel/archive/sm8250-6.19/0004-arm64-dts-qcom-sm8250-xiaomi-elish-enable-touchscree.patch"
        "patches/kernel/archive/sm8250-6.19/0005-ASoC-qcom-sm8250-Add-tdm-support.patch"
        "patches/kernel/archive/sm8250-6.19/0006-arm64-dts-qcom-sm8250-xiaomi-elish-Add-sound-support.patch"
        "patches/kernel/archive/sm8250-6.19/0007-Asoc-wm_adsp-Add-prefix-support.patch"
        "patches/kernel/archive/sm8250-6.19/0008-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-Add-dev.patch"
        "patches/kernel/archive/sm8250-6.19/0009-drm-msm-dsi-change-sync-mode-to-sync-on-DSI0-rather-.patch"
        "patches/kernel/archive/sm8250-6.19/0010-arm64-dts-qcom-sm8250-xiaomi-elish-add-keyboard-supp.patch"
        "patches/kernel/archive/sm8250-6.19/0011-arm64-dts-qcom-sm8250-oneplus-kebab-Add-device-tree-.patch"
        "patches/kernel/archive/sm8250-6.19/0012-arm64-dts-qcom-sm8250-xiaomi-elish-remove-framebuffe.patch"
        "patches/kernel/archive/sm8250-6.19/0013-input-nt36xxx-Enable-pen-support.patch"
        "patches/kernel/archive/sm8250-6.19/0014-nt36xxx-add-pen-input-resolution.patch"
        "patches/kernel/archive/sm8250-6.19/0015-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-Restore.patch"
        "patches/kernel/archive/sm8250-6.19/0016-drm-panel-Add-panel-driver-for-samsung-amsa26zp01.patch"
        "patches/kernel/archive/sm8250-6.19/0017-ASoC-cs35l45-disable-power-managerment.patch"
        "patches/kernel/archive/sm8250-6.19/0018-ASoC-cs35l45-Add-ASPRX-1-2-Slot-Position.patch"
        "patches/kernel/archive/sm8250-6.19/0019-ASoC-qcom-sm8250-Add-primary-tdm-support.patch"
        "patches/kernel/archive/sm8250-6.19/0020-arm64-dts-qcom-add-device-tree-for-Xiaoxin-Pad-Pro-1.patch"
        "patches/kernel/archive/sm8250-6.19/0021-power-supply-add-bq25970-charger-driver.patch"
        "patches/kernel/archive/sm8250-6.19/0022-arm64-dts-qcom-sm8250-xiaomi-elish-add-bq25970-charg.patch"
        "patches/kernel/archive/sm8250-6.19/0023-arm64-dts-qcom-sm8250-xiaomi-elish-add-flash-led-nod.patch"
        "patches/kernel/archive/sm8250-6.19/0024-power-supply-Add-driver-for-Qualcomm-PMIC-fuel-gauge.patch"
        "patches/kernel/archive/sm8250-6.19/0025-power-qcom_fg-Add-initial-pm8150b-support.patch"
        "patches/kernel/archive/sm8250-6.19/0026-qcom_fg-Fix-compilation-in-6.11.patch"
        "patches/kernel/archive/sm8250-6.19/0027-arm64-dts-qcom-pm8150b-Add-fuel-gauge.patch"
        "patches/kernel/archive/sm8250-6.19/0028-From-Teguh-Sobirin-teguh-sobir.in-Date-Sun-24-Nov-20.patch"
        "patches/kernel/archive/sm8250-6.19/0029-From-Teguh-Sobirin-teguh-sobir.in-Date-Wed-20-Nov-20.patch"
        "patches/kernel/archive/sm8250-6.19/0030-power-supply-qcom_fg-invert-charging-current.patch"
        "patches/kernel/archive/sm8250-6.19/0031-arm64-dts-qcom-sm8250-xiaomi-elish-add-pm8150b-charg.patch"
        "patches/kernel/archive/sm8250-6.19/0032-drm-panel-samsung-amsa26zp01-backlight-add-Smooth-di.patch"
        "patches/kernel/archive/sm8250-6.19/0033-Revert-ASoC-cs35l45-disable-power-managerment.patch"
        "patches/kernel/archive/sm8250-6.19/0034-arm64-dts-qcom-sm8250-lenovo-q706f-clean-up-devicetr.patch"
        "patches/kernel/archive/sm8250-6.19/0035-arm64-dts-qcom-sm8250-lenovo-q706f-Add-hall-sensor-f.patch"
        "patches/kernel/archive/sm8250-6.19/0036-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-swtich-.patch"
        "patches/kernel/archive/sm8250-6.19/0037-power-supply-qcom_pm8150b_charger-adds-charging-cont.patch"
        "patches/kernel/archive/sm8250-6.19/0038-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-adds-us.patch"
        "patches/kernel/archive/sm8250-6.19/0039-power-supply-qcom_pm8150b_charger-clean-up.patch"
        "patches/kernel/archive/sm8250-6.19/0040-arm64-dts-qcom-sm8250-oneplus-instantnoodlep-add-mis.patch"
        "patches/kernel/archive/sm8250-6.19/0041-power-supply-qcom_pm8150b_charger-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.19/0042-power-supply-qcom_fg-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.19/0043-power-supply-bq25970_charger-fix-compile-error.patch"
        "patches/kernel/archive/sm8250-6.19/0044-arm64-dts-qcom-sm8250-xiaomi-elish-set-9V3A-charging.patch"
        "patches/kernel/archive/sm8250-6.19/0047-arm64-dts-qcom-sm8250-xiaomi-elish-add-sleep-pinctrl.patch"
        "patches/kernel/archive/sm8250-6.19/0048-arm64-dts-qcom-sm8250-xiaomi-elish-fix-wlan-default-.patch"
        "patches/kernel/archive/sm8250-6.19/0049-arm64-dts-qcom-sm8250-xiaomi-elish-add-enable-and-sw.patch"
        "patches/kernel/archive/sm8250-6.19/0050-arm64-dts-qcom-sm8250-xiaomi-elish-add-BT-swctrl-gpi.patch"
        "patches/kernel/archive/sm8250-6.19/0052-arm64-dts-qcom-sm8250-Add-device-tree-for-Xiaomi-Mi-.patch"
        "patches/kernel/archive/sm8250-6.19/0053-arm64-dts-qcom-sm8250-xiaomi-enuma-enable-PCIe2-node.patch"
        "patches/kernel/archive/sm8250-6.19/0054-arm64-dts-qcom-sm8250-xiaomi-elish-add-label-to-WiFi.patch"
        "patches/kernel/archive/sm8250-6.19/0055-arm64-dts-qcom-sm8250-xiaomi-enuma-use-own-WLAN-cali.patch"
        "patches/kernel/archive/sm8250-6.19/0056-arm64-dts-qcom-sm8250-remote-heap-CMA-for-ADSP-CDSP-.patch"
        "patches/kernel/archive/sm8250-6.19/0057-arm64-dts-qcom-sm8250-add-external-modem-s-AP-MDM-pi.patch"
        "patches/kernel/archive/sm8250-6.19/0058-arm64-dts-qcom-sm8250-xiaomi-elish-add-reset-pin-set.patch"
        "patches/kernel/archive/sm8250-6.19/0059-arm64-dts-qcom-sm8250-xiaomi-elish-add-pin-setting-f.patch"
        "patches/kernel/archive/sm8250-6.19/0060-arm64-dts-qcom-sm8250-xiaomi-elish-add-hall-key.patch"
        "patches/kernel/archive/sm8250-6.19/0061-Revert-misc-fastrpc-Rename-tgid-and-pid-to-client_id.patch"
        "patches/kernel/archive/sm8250-6.19/0062-Revert-misc-fastrpc-Add-support-for-multiple-PD-from.patch"
        "patches/kernel/archive/sm8250-6.19/0064-arm64-dts-qcom-sm8250-add-uart16-Signed-off-by-Teguh.patch"
        "patches/kernel/archive/sm8250-6.19/0065-drm-panel-Add-DDIC-CH13726A-panel-Signed-off-by-Tegu.patch"
        "patches/kernel/archive/sm8250-6.19/0066-leds-Add-driver-for-HEROIC-HTR3212-Signed-off-by-Teg.patch"
        "patches/kernel/archive/sm8250-6.19/0067-Input-driver-for-AYN-Odin2-Gamepad.patch"
        "patches/kernel/archive/sm8250-6.19/0068-input-add-Qualcomm-SPMI-haptics-driver.patch"
        "patches/kernel/archive/sm8250-6.19/0069-arm64-dts-qcom-pm8150b-introduce-spmi-haptics.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "sm8250";
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
