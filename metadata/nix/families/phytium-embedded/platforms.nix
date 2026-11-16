{
  "phytium-embedded-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.6";
      config = "linux-phytium-embedded-current";
      config_path = "config/kernel/linux-phytium-embedded-current.config";
      config_path_nix = "configs/linux-phytium-embedded-current.config";
      exact_version = "6.6.12";
      hash = "sha256-pe3lbA4gTnYPiKacR93eVqgNZm2dmY/m2E1TaO5Dtyw=";
      major_minor = "6.6";
      nvfetcher_key = "kernel-phytium-embedded-branch-linux-6-6";
      patch_dir = "phytium-embedded-current";
      patches = [ ];
      source = "https://github.com/chainsx/phytium-linux-kernel";
    };
    linux_family = "phytium-embedded";
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
  "phytium-embedded-legacy" = {
    arch = "arm64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.6";
      config = "linux-phytium-embedded-legacy";
      config_path = "config/kernel/linux-phytium-embedded-legacy.config";
      config_path_nix = "configs/linux-phytium-embedded-legacy.config";
      exact_version = "6.6.12";
      hash = "sha256-pe3lbA4gTnYPiKacR93eVqgNZm2dmY/m2E1TaO5Dtyw=";
      major_minor = "6.6";
      nvfetcher_key = "kernel-phytium-embedded-branch-linux-6-6";
      patch_dir = "phytium-embedded-legacy";
      patches = [ ];
      source = "https://github.com/chainsx/phytium-linux-kernel";
    };
    linux_family = "phytium-embedded";
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
