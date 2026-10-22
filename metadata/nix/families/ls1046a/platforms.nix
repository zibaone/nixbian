{
  "ls1046a-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "tag:lf-6.12.49-2.2.0";
      config = "linux-ls1046a-current";
      config_path = "config/kernel/linux-ls1046a-current.config";
      config_path_nix = "configs/linux-ls1046a-current.config";
      exact_version = "6.12.49";
      hash = "sha256-+cYjZ26Hx4tGR1tVz4p47TF4HG/9IS1tDnLIDDWsRFA=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-ls1046a-tag-lf-6-12-49-2-2-0";
      patch_dir = "archive/ls1046a-6.12";
      patches = [
        "patches/kernel/archive/ls1046a-6.12/001-hwmon-ina2xx-Add-INA234-support.patch"
        "patches/kernel/archive/ls1046a-6.12/002-arm64-dts-Add-Mono-Gateway-DK-device-tree.patch"
        "patches/kernel/archive/ls1046a-6.12/004-libbpf-const-correctness-for-newer-glibc.patch"
      ];
      source = "https://github.com/nxp-qoriq/linux.git";
    };
    linux_family = "ls1046a";
    uboot = {
      atf_branch = "\${ATFBRANCH:?ATFBRANCH must be set by board config}";
      atf_hash = null;
      atf_nvfetcher_key = "src-atfsource-atfsource-must-be-set-by-board-config-atfbranch-atfbranch-must-be-set-by-board-config";
      atf_platform = null;
      atf_source = "\${ATFSOURCE:?ATFSOURCE must be set by board config}";
      atf_target_map = "PLAT=\${LS1046A_PLAT:?LS1046A_PLAT must be set by board config} bl31;;build/\${LS1046A_PLAT:?LS1046A_PLAT must be set by board config}/release/bl31.bin";
      branch = "\${BOOTBRANCH:?BOOTBRANCH must be set by board config}";
      config = "mono_gateway_dk_defconfig";
      nvfetcher_key = "uboot-bootbranch-bootbranch-must-be-set-by-board-config";
      patch_dir = "u-boot-ls1046a";
      patches = [ ];
      source = "\${BOOTSOURCE:?BOOTSOURCE must be set by board config}";
      source_hash = null;
      target_map = "\${UBOOT_TARGET_MAP:?UBOOT_TARGET_MAP must be set by board config}";
    };
  };
}
