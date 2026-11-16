{
  "sun55iw3-syterkit-legacy" = {
    arch = "arm64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-5.15";
      config = "linux-sun55iw3-syterkit-legacy";
      config_path = "config/kernel/linux-sun55iw3-syterkit-legacy.config";
      config_path_nix = "configs/linux-sun55iw3-syterkit-legacy.config";
      exact_version = "5.15.154";
      hash = "sha256-3qys8OvtoGpW6VdWZssX6yHX5djHcwBRt8lvK/bs1GI=";
      major_minor = "5.15";
      nvfetcher_key = "kernel-sun55iw3-syterkit-branch-linux-5-15";
      patch_dir = "sun55iw3-syterkit-legacy";
      patches = [ ];
      source = "https://github.com/AvaotaSBC/linux.git";
    };
    linux_family = "sun55iw3-syterkit";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2022.07";
      config = null;
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = null;
      patches = null;
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = null;
    };
  };
}
