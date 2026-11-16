{
  "qcs6490-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.2";
      config = "linux-qcs6490-current";
      config_path = "config/kernel/linux-qcs6490-current.config";
      config_path_nix = "configs/linux-qcs6490-current.config";
      exact_version = "6.18.2";
      hash = "sha256-w3tGDX694Vw0Kv3IocdrxJ8/7PnZxarcmjJWK2qxSBk=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-qcs6490-branch-linux-6-18-2";
      patch_dir = "archive/qcs6490-6.18";
      patches = [ ];
      source = "https://github.com/radxa/kernel.git";
    };
    linux_family = "qcs6490";
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
