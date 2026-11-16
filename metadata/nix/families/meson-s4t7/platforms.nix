{
  "meson-s4t7-legacy" = {
    arch = "arm64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:khadas-vims-5.15.y";
      config = "linux-meson-s4t7-legacy";
      config_path = "config/kernel/linux-meson-s4t7-legacy.config";
      config_path_nix = "configs/linux-meson-s4t7-legacy.config";
      exact_version = "5.15.137";
      hash = "sha256-VuGB50NhujJWsnDym4Ahv5zxa1TaP/VzhdN7PluuuwQ=";
      major_minor = "5.15";
      nvfetcher_key = "kernel-meson-s4t7-branch-khadas-vims-5-15-y";
      patch_dir = "archive/meson-s4t7-5.15";
      patches = [
        "patches/kernel/archive/meson-s4t7-5.15/Makefile-don-t-try-to-modify-git-hooks.patch"
        "patches/kernel/archive/meson-s4t7-5.15/drm-meson-fbdev-remove-drm-wait-one-vblank.patch"
      ];
      source = "https://github.com/khadas/linux.git";
    };
    linux_family = "meson-s4t7";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "branch:khadas-vims-v2019.01";
      config = "kvim1s_defconfig";
      nvfetcher_key = "uboot-branch-khadas-vims-v2019-01";
      patch_dir = "u-boot-meson-s4t7";
      patches = [
        "patches/uboot/u-boot-meson-s4t7/Mod-default-bootargs.patch"
        "patches/uboot/u-boot-meson-s4t7/Revert-config_distro_bootcmd.h-boot-only-from-boot.i.patch"
        "patches/uboot/u-boot-meson-s4t7/Update-kvim4_defconfig.patch"
        "patches/uboot/u-boot-meson-s4t7/allow-aarch64-compilation.patch"
        "patches/uboot/u-boot-meson-s4t7/fix-docker-crash-when-building-u-boot-on-certain-com.patch"
      ];
      source = "https://github.com/CoreELEC/u-boot.git";
      source_hash = "sha256-e2IofapTBrx4uxSY+fCNztKhDH30KmLHAbnjnArg+TE=";
      target_map = ";;fip/_tmp/u-boot.bin.sd.bin.signed:u-boot.bin.sd.bin.signed";
    };
  };
}
