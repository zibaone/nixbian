{
  "starfive2-vendor" = {
    arch = "riscv64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:JH7110_VisionFive2_6.6.y_devel";
      config = "linux-starfive2-vendor";
      config_path = "config/kernel/linux-starfive2-vendor.config";
      config_path_nix = "configs/linux-starfive2-vendor.config";
      exact_version = "6.6.20";
      hash = "sha256-RWZ/BYKiV2+MnxmIbYV9oqdG+w9XLKByzzaTdL0s2sE=";
      major_minor = "6.6";
      nvfetcher_key = "kernel-starfive2-branch-jh7110-visionfive2-6-6-y-devel";
      patch_dir = "starfive2-vendor";
      patches = [ ];
      source = "https://github.com/starfive-tech/linux";
    };
    linux_family = "starfive2";
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
