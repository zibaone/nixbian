{
  "qrb2210-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "tag:v7.0";
      config = "linux-qrb2210-edge";
      config_path = "config/kernel/linux-qrb2210-edge.config";
      config_path_nix = "configs/linux-qrb2210-edge.config";
      exact_version = "7.0.0";
      hash = "sha256-7TjYHhJdD67P3lquusrjjVtUIUzhLPtA5Oy7tc82gYA=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-qrb2210-tag-v7-0";
      patch_dir = "qrb2210-edge";
      patches = [
        "patches/kernel/qrb2210-edge/0001-dt-bindings-drm-bridge-anx7625-describe-Type-C-conne.patch"
        "patches/kernel/qrb2210-edge/0002-drm-bridge-anx7625-implement-minimal-Type-C-support.patch"
        "patches/kernel/qrb2210-edge/0003-drm-bridge-anx7625-implement-message-sending.patch"
        "patches/kernel/qrb2210-edge/0004-drm-bridge-anx7625-correctly-detect-if-PD-can-be-dis.patch"
        "patches/kernel/qrb2210-edge/0005-dt-bindings-mfd-qcom-spmi-pmic-add-compatibles-for-p.patch"
        "patches/kernel/qrb2210-edge/0006-arm64-dts-qcom-agatti-add-LPASS-devices.patch"
        "patches/kernel/qrb2210-edge/0007-arm64-dts-arduino-imola-add-support-for-sound.patch"
        "patches/kernel/qrb2210-edge/0008-arm64-defconfig-Enable-Agatti-audio-drivers.patch"
        "patches/kernel/qrb2210-edge/0009-arm64-dts-qcom-qrb2210-arduino-imola-describe-DSI-DP.patch"
        "patches/kernel/qrb2210-edge/0010-drm-bridge-anx7625-don-t-crash-if-Type-C-port-is-not.patch"
        "patches/kernel/qrb2210-edge/0011-arm64-dts-qcom-arduino-imola-fix-faulty-spidev-node.patch"
        "patches/kernel/qrb2210-edge/0012-drm-msm-add-missing-MODULE_DEVICE_ID-definitions.patch"
        "patches/kernel/qrb2210-edge/0013-ASoC-codecs-pm4125-fix-array-out-of-bounds.patch"
        "patches/kernel/qrb2210-edge/0014-ASoC-qcom-common-setup-fe-dais-before-be-dais.patch"
        "patches/kernel/qrb2210-edge/0015-arm64-dts-qcom-imola-add-support-for-media-carrier-b.patch"
        "patches/kernel/qrb2210-edge/0016-remoteproc-qcom_q6v5_pas-explicitly-list-firmware-fo.patch"
        "patches/kernel/qrb2210-edge/0017-gpu-drm-msm-add-explicit-firmware-for-a702.patch"
        "patches/kernel/qrb2210-edge/0018-ASoC-qcom-sm8250-set-capture-channels-correctly.patch"
        "patches/kernel/qrb2210-edge/0019-ASoC-qcom-sm8250-set-i2s-format-needs.patch"
        "patches/kernel/qrb2210-edge/0020-ASoC-qcom-q6dsp-add-32-bit-support-for-i2s-backend-d.patch"
        "patches/kernel/qrb2210-edge/0021-anx7625-allow-32-bit-format.patch"
        "patches/kernel/qrb2210-edge/0022-drm-anx7625-set-I2S-input-stream-as-right-justified.patch"
        "patches/kernel/qrb2210-edge/0023-ASoC-qcom-qdsp6-fix-microphone-stream-re-enable.patch"
        "patches/kernel/qrb2210-edge/0024-ASoC-codecs-pm4125-harden-swr-discovery-path.patch"
        "patches/kernel/qrb2210-edge/0025-dt-bindings-display-panel-himax-hx83102-describe-Wav.patch"
        "patches/kernel/qrb2210-edge/0026-dt-bindings-display-panel-himax-hx8394-describe-Wave.patch"
        "patches/kernel/qrb2210-edge/0027-dt-bindings-display-panel-jadard-jd9365da-h3-describ.patch"
        "patches/kernel/qrb2210-edge/0028-dt-bindings-display-panel-ilitek-ili9881c-describe-W.patch"
        "patches/kernel/qrb2210-edge/0029-dt-bindings-dipslay-panel-describe-panels-using-Foca.patch"
        "patches/kernel/qrb2210-edge/0030-drm-of-add-helper-to-count-data-lanes-on-a-remote-en.patch"
        "patches/kernel/qrb2210-edge/0031-drm-panel-himax-hx83102-support-Waveshare-12.3-DSI-p.patch"
        "patches/kernel/qrb2210-edge/0032-drm-panel-himax-hx8394-set-prepare_prev_first.patch"
        "patches/kernel/qrb2210-edge/0033-drm-panel-himax-hx8394-simplify-hx8394_enable.patch"
        "patches/kernel/qrb2210-edge/0034-drm-panel-himax-hx8394-support-Waveshare-DSI-panels.patch"
        "patches/kernel/qrb2210-edge/0035-drm-panel-jadard-jd9365da-h3-use-drm_connector_helpe.patch"
        "patches/kernel/qrb2210-edge/0036-drm-panel-jadard-jd9365da-h3-support-variable-DSI-co.patch"
        "patches/kernel/qrb2210-edge/0037-drm-panel-jadard-jd9365da-h3-set-prepare_prev_first.patch"
        "patches/kernel/qrb2210-edge/0038-drm-panel-jadard-jd9365da-h3-support-Waveshare-round.patch"
        "patches/kernel/qrb2210-edge/0039-drm-panel-jadard-jd9365da-h3-support-Waveshare-WXGA-.patch"
        "patches/kernel/qrb2210-edge/0040-drm-panel-jadard-jd9365da-h3-support-Waveshare-720p-.patch"
        "patches/kernel/qrb2210-edge/0041-drm-panel-ilitek-ili9881c-support-Waveshare-7.0-DSI-.patch"
        "patches/kernel/qrb2210-edge/0042-drm-panel-add-devm_drm_panel_add-helper.patch"
        "patches/kernel/qrb2210-edge/0043-drm-panel-add-driver-for-Waveshare-8.8-DSI-TOUCH-A-p.patch"
        "patches/kernel/qrb2210-edge/0044-dt-bindings-gpio-describe-Waveshare-GPIO-controller.patch"
        "patches/kernel/qrb2210-edge/0045-gpio-add-GPIO-controller-found-on-Waveshare-DSI-TOUC.patch"
        "patches/kernel/qrb2210-edge/0046-dt-bindings-display-waveshare-dsp2dpi-describe-DSI2L.patch"
        "patches/kernel/qrb2210-edge/0047-drm-bridge-waveshare-dsi-support-DSI-LCD-kits-with-L.patch"
        "patches/kernel/qrb2210-edge/0048-arch-arm64-qcom-imola-Align-panel-DTBO.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "qrb2210";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2022.07";
      config = "qcom_defconfig";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = "u-boot-qrb2210";
      patches = [
        "patches/uboot/u-boot-qrb2210/0001-qcom-add-extlinux.patch"
        "patches/uboot/u-boot-qrb2210/0002-u-boot-use-extlinux.patch"
      ];
      source = "https://github.com/arduino/u-boot.git";
      source_hash = null;
      target_map = "4};;u-boot.bin boot.img";
    };
  };
}
