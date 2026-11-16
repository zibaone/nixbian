{
  "k3-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:ti-linux-6.18.y";
      config = "linux-k3-edge";
      config_path = "config/kernel/linux-k3-edge.config";
      config_path_nix = "configs/linux-k3-edge.config";
      exact_version = "6.18.51";
      hash = "sha256-rru3xmmEBiijhgls0baWjFfrwEwydpKdfObQxlJxT6I=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-k3-branch-ti-linux-6-18-y";
      patch_dir = "archive/k3-6.18";
      patches = [ ];
      source = "https://github.com/TexasInstruments/ti-linux-kernel";
    };
    linux_family = "k3";
    uboot = {
      atf_branch = "branch:ti-tfa-2.14.y";
      atf_hash = "sha256-8DsD20PyEg+5ipgHa6XcTdBUNNwqGyGxzBp9gk9K9js=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-branch-ti-tfa-2-14-y";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=generic SPD=opteed \${ATF_ARGS} all;;build/k3/generic/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:ti-u-boot-2026.01";
      config = "j721e_beagleboneai64_a72_defconfig";
      nvfetcher_key = "uboot-branch-ti-u-boot-2026-01";
      patch_dir = null;
      patches = null;
      source = "https://github.com/TexasInstruments/ti-u-boot";
      source_hash = "sha256-ifK2r8r9ywO8LaQ4jaUK/i+I5TerP7mLP5jiMneZfC0=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
  "k3-vendor" = {
    arch = "arm64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:ti-linux-6.18.y";
      config = "linux-k3-vendor";
      config_path = "config/kernel/linux-k3-vendor.config";
      config_path_nix = "configs/linux-k3-vendor.config";
      exact_version = "6.18.51";
      hash = "sha256-rru3xmmEBiijhgls0baWjFfrwEwydpKdfObQxlJxT6I=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-k3-branch-ti-linux-6-18-y";
      patch_dir = "archive/k3-6.18";
      patches = [ ];
      source = "https://github.com/TexasInstruments/ti-linux-kernel";
    };
    linux_family = "k3";
    uboot = {
      atf_branch = "branch:ti-tfa-2.14.y";
      atf_hash = "sha256-8DsD20PyEg+5ipgHa6XcTdBUNNwqGyGxzBp9gk9K9js=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-branch-ti-tfa-2-14-y";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=generic SPD=opteed \${ATF_ARGS} all;;build/k3/generic/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:ti-u-boot-2026.01";
      config = "j721e_beagleboneai64_a72_defconfig";
      nvfetcher_key = "uboot-branch-ti-u-boot-2026-01";
      patch_dir = null;
      patches = null;
      source = "https://github.com/TexasInstruments/ti-u-boot";
      source_hash = "sha256-ifK2r8r9ywO8LaQ4jaUK/i+I5TerP7mLP5jiMneZfC0=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
  "k3-vendor-edge" = {
    arch = "arm64";
    branch = "vendor-edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:ti-linux-6.18.y";
      config = "linux-k3-vendor-edge";
      config_path = "config/kernel/linux-k3-vendor-edge.config";
      config_path_nix = "configs/linux-k3-vendor-edge.config";
      exact_version = "6.18.51";
      hash = "sha256-rru3xmmEBiijhgls0baWjFfrwEwydpKdfObQxlJxT6I=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-k3-branch-ti-linux-6-18-y";
      patch_dir = "archive/k3-6.18";
      patches = [ ];
      source = "https://github.com/TexasInstruments/ti-linux-kernel";
    };
    linux_family = "k3";
    uboot = {
      atf_branch = "branch:ti-tfa-2.14.y";
      atf_hash = "sha256-8DsD20PyEg+5ipgHa6XcTdBUNNwqGyGxzBp9gk9K9js=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-branch-ti-tfa-2-14-y";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=lite SPD=opteed \${ATF_ARGS} all;;build/k3/lite/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:ti-u-boot-2026.01";
      config = "am62x_lpsk_a53_defconfig";
      nvfetcher_key = "uboot-branch-ti-u-boot-2026-01";
      patch_dir = null;
      patches = null;
      source = "https://github.com/TexasInstruments/ti-u-boot";
      source_hash = "sha256-ifK2r8r9ywO8LaQ4jaUK/i+I5TerP7mLP5jiMneZfC0=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
  "k3-vendor-rt" = {
    arch = "arm64";
    branch = "vendor-rt";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:ti-linux-6.18.y";
      config = "linux-k3-vendor-rt";
      config_path = "config/kernel/linux-k3-vendor-rt.config";
      config_path_nix = "configs/linux-k3-vendor-rt.config";
      exact_version = "6.18.51";
      hash = "sha256-rru3xmmEBiijhgls0baWjFfrwEwydpKdfObQxlJxT6I=";
      major_minor = "6.18";
      nvfetcher_key = "kernel-k3-branch-ti-linux-6-18-y";
      patch_dir = "archive/k3-6.18";
      patches = [ ];
      source = "https://github.com/TexasInstruments/ti-linux-kernel";
    };
    linux_family = "k3";
    uboot = {
      atf_branch = "branch:ti-tfa-2.14.y";
      atf_hash = "sha256-8DsD20PyEg+5ipgHa6XcTdBUNNwqGyGxzBp9gk9K9js=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-branch-ti-tfa-2-14-y";
      atf_platform = "k3";
      atf_source = "https://github.com/TexasInstruments/arm-trusted-firmware";
      atf_target_map = "PLAT=k3 TARGET_BOARD=generic SPD=opteed \${ATF_ARGS} all;;build/k3/generic/release/bl31.bin:bl31.bin \${EXTRA_ATF_TARGETS}";
      branch = "branch:ti-u-boot-2026.01";
      config = "j721e_beagleboneai64_a72_defconfig";
      nvfetcher_key = "uboot-branch-ti-u-boot-2026-01";
      patch_dir = null;
      patches = null;
      source = "https://github.com/TexasInstruments/ti-u-boot";
      source_hash = "sha256-ifK2r8r9ywO8LaQ4jaUK/i+I5TerP7mLP5jiMneZfC0=";
      target_map = "BL31=bl31.bin \${EXTRA_BOOT_ARGS} TEE=cache/sources/optee-os/out/arm-plat-k3/core/tee-pager_v2.bin BINMAN_INDIRS=cache/sources/ti-linux-firmware all;;tiboot3.bin \${SYSFW_FILE:+sysfw.itb} tispl.bin u-boot.img";
    };
  };
}
