{
  "k3-beagle-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:v6.12.49-ti-arm64-r56";
      config = "linux-k3-beagle-edge";
      config_path = "config/kernel/linux-k3-beagle-edge.config";
      config_path_nix = "configs/linux-k3-beagle-edge.config";
      exact_version = "6.12.49";
      hash = "sha256-eNoreZyo7GCWGAi0eYQX3Ui34LqsDsyrbViYdxr/DcU=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-k3-beagle-branch-v6-12-49-ti-arm64-r56";
      patch_dir = "archive/k3-beagle-6.12";
      patches = [ ];
      source = "https://github.com/beagleboard/linux";
    };
    linux_family = "k3-beagle";
    uboot = {
      atf_branch = "tag:11.00.09";
      atf_hash = "sha256-of5+mD5Plb12pIsx0yqk8warV3MhV3fJJZtFcxKCyM8=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-tag-11-00-09";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed \${ATF_ARGS} all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:v2025.07-am6232-pocketbeagle2";
      config = "am67a_beagley_ai_a53_defconfig";
      nvfetcher_key = "uboot-branch-v2025-07-am6232-pocketbeagle2";
      patch_dir = null;
      patches = null;
      source = "https://github.com/beagleboard/u-boot";
      source_hash = "sha256-iXuEOmr8TDHUisFiZhDajMS0C30K7uB3XwSpV6pcM3s=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
  "k3-beagle-vendor" = {
    arch = "arm64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:v6.12.49-ti-arm64-r56";
      config = "linux-k3-beagle-vendor";
      config_path = "config/kernel/linux-k3-beagle-vendor.config";
      config_path_nix = "configs/linux-k3-beagle-vendor.config";
      exact_version = "6.12.49";
      hash = "sha256-eNoreZyo7GCWGAi0eYQX3Ui34LqsDsyrbViYdxr/DcU=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-k3-beagle-branch-v6-12-49-ti-arm64-r56";
      patch_dir = "archive/k3-beagle-6.12";
      patches = [ ];
      source = "https://github.com/beagleboard/linux";
    };
    linux_family = "k3-beagle";
    uboot = {
      atf_branch = "tag:11.00.09";
      atf_hash = "sha256-of5+mD5Plb12pIsx0yqk8warV3MhV3fJJZtFcxKCyM8=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-tag-11-00-09";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed \${ATF_ARGS} all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:v2025.07-am6232-pocketbeagle2";
      config = "am67a_beagley_ai_a53_defconfig";
      nvfetcher_key = "uboot-branch-v2025-07-am6232-pocketbeagle2";
      patch_dir = null;
      patches = null;
      source = "https://github.com/beagleboard/u-boot";
      source_hash = "sha256-iXuEOmr8TDHUisFiZhDajMS0C30K7uB3XwSpV6pcM3s=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
  "k3-beagle-vendor-rt" = {
    arch = "arm64";
    branch = "vendor-rt";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:v6.12.49-ti-arm64-r56";
      config = "linux-k3-beagle-vendor-rt";
      config_path = "config/kernel/linux-k3-beagle-vendor-rt.config";
      config_path_nix = "configs/linux-k3-beagle-vendor-rt.config";
      exact_version = "6.12.49";
      hash = "sha256-eNoreZyo7GCWGAi0eYQX3Ui34LqsDsyrbViYdxr/DcU=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-k3-beagle-branch-v6-12-49-ti-arm64-r56";
      patch_dir = "archive/k3-beagle-6.12";
      patches = [ ];
      source = "https://github.com/beagleboard/linux";
    };
    linux_family = "k3-beagle";
    uboot = {
      atf_branch = "tag:11.00.09";
      atf_hash = "sha256-of5+mD5Plb12pIsx0yqk8warV3MhV3fJJZtFcxKCyM8=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-tag-11-00-09";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed \${ATF_ARGS} all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:v2025.07-am6232-pocketbeagle2";
      config = "am67a_beagley_ai_a53_defconfig";
      nvfetcher_key = "uboot-branch-v2025-07-am6232-pocketbeagle2";
      patch_dir = null;
      patches = null;
      source = "https://github.com/beagleboard/u-boot";
      source_hash = "sha256-iXuEOmr8TDHUisFiZhDajMS0C30K7uB3XwSpV6pcM3s=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
}
