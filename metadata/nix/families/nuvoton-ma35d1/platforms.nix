{
  "nuvoton-ma35d1-vendor" = {
    arch = "arm64";
    branch = "vendor";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:master";
      config = "linux-nuvoton-ma35d1-vendor";
      config_path = "config/kernel/linux-nuvoton-ma35d1-vendor.config";
      config_path_nix = "configs/linux-nuvoton-ma35d1-vendor.config";
      exact_version = "5.10.140";
      hash = "sha256-gYZEyHBzpGo8LOq3xtmRK0Ke7ocenKx78BDbcXtAQVs=";
      major_minor = "5.10";
      nvfetcher_key = "kernel-nuvoton-ma35d1-branch-master";
      patch_dir = "nuvoton-ma35d1-vendor";
      patches = [ ];
      source = "https://github.com/OpenNuvoton/MA35D1_linux-5.10.y.git";
    };
    linux_family = "nuvoton-ma35d1";
    uboot = {
      atf_branch = "branch:master";
      atf_hash = "sha256-DfXvKk5HKLKMKMZqLIGN849Pr5jylUiYljKz8QmYxZ4=";
      atf_nvfetcher_key = "src-ma35d1-arm-trusted-firmware-v2-3-branch-master";
      atf_platform = "ma35d1";
      atf_source = "https://github.com/OpenNuvoton/MA35D1_arm-trusted-firmware-v2.3.git";
      atf_target_map = "PLAT=ma35d1 DEBUG=1 DTB_FILE_NAME=ma35d1-cpu800-wb-512m.dtb bl2 bl31 dtbs;;build/ma35d1/debug/bl2.bin build/ma35d1/debug/bl31.bin build/ma35d1/debug/fdts/ma35d1-cpu800-wb-512m.dtb:bl2-ma35d1.dtb";
      branch = "branch:master";
      config = "ma35d1_sdcard1_defconfig";
      nvfetcher_key = "uboot-branch-master";
      patch_dir = "u-boot-nuvoton-ma35d1";
      patches = [ "patches/uboot/u-boot-nuvoton-ma35d1/0001-Set-bootcmd-for-Armbian.patch" ];
      source = "https://github.com/OpenNuvoton/MA35D1_u-boot-v2020.07.git";
      source_hash = "sha256-INtqXTbRZdnHpy5ueI+fjk4dMfnqRUBAcgkE0zEcpZk=";
      target_map = ";;u-boot.bin header.bin fip.bin bl2.bin bl31.bin bl2-ma35d1.dtb tee-header_v2.bin tee-pager_v2.bin";
    };
  };
}
