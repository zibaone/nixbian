{
  "bcm2711-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:rpi-7.0.y";
      config = "linux-bcm2711-current";
      config_path = "config/kernel/linux-bcm2711-current.config";
      config_path_nix = "configs/linux-bcm2711-current.config";
      exact_version = "7.0.14";
      hash = "sha256-W0TAwvdEfn7YeehXUpYFsurRWjePqUzKNqk0YsCgnnk=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-bcm2711-branch-rpi-7-0-y";
      patch_dir = "archive/bcm2711-7.0";
      patches = [ ];
      source = "https://github.com/raspberrypi/linux";
    };
    linux_family = "bcm2711";
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
  "bcm2711-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:rpi-7.0.y";
      config = "linux-bcm2711-edge";
      config_path = "config/kernel/linux-bcm2711-edge.config";
      config_path_nix = "configs/linux-bcm2711-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-W0TAwvdEfn7YeehXUpYFsurRWjePqUzKNqk0YsCgnnk=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-bcm2711-branch-rpi-7-0-y";
      patch_dir = "archive/bcm2711-7.0";
      patches = [ ];
      source = "https://github.com/raspberrypi/linux";
    };
    linux_family = "bcm2711";
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
  "bcm2711-legacy" = {
    arch = "arm64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:rpi-7.0.y";
      config = "linux-bcm2711-legacy";
      config_path = "config/kernel/linux-bcm2711-legacy.config";
      config_path_nix = "configs/linux-bcm2711-legacy.config";
      exact_version = "7.0.14";
      hash = "sha256-W0TAwvdEfn7YeehXUpYFsurRWjePqUzKNqk0YsCgnnk=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-bcm2711-branch-rpi-7-0-y";
      patch_dir = "archive/bcm2711-7.0";
      patches = [ ];
      source = "https://github.com/raspberrypi/linux";
    };
    linux_family = "bcm2711";
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
