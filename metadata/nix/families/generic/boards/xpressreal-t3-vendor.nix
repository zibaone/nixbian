{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "xpressreal-t3";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:v6.6.54-xpressreal-t3";
    config = "linux-xpressreal-t3-6.6";
    config_path = "config/kernel/linux-xpressreal-t3-6.6.config";
    config_path_nix = "configs/linux-xpressreal-t3-6.6.config";
    exact_version = "6.6.54";
    hash = "sha256-9zoctsV7dRltd9laKcCSN+wREyv43R3v8R+nHwN9XC0=";
    major_minor = "6.6";
    nvfetcher_key = "kernel-generic-branch-v6-6-54-xpressreal-t3";
    patch_dir = "archive/\${LINUXFAMILY}-6.6";
    patches = [ ];
    source = "https://github.com/XpressReal/linux.git";
  };
  kernel_params = null;
  uboot = {
    branch = "branch:v2024.01-xpressreal";
    config = "rtd1619b_bleedingedge_defconfig";
    nvfetcher_key = "uboot-branch-v2024-01-xpressreal";
    patch_dir = "u-boot-xpressreal";
    patches = [
      "patches/uboot/u-boot-xpressreal/0001-Update-dev-signing-key.patch"
      "patches/uboot/u-boot-xpressreal/0002-update-fw-path.patch"
    ];
    source = "https://github.com/XpressReal/u-boot.git";
    source_hash = "sha256-Jwzsd1hU6HDVeV5SIeLHNVSxDUIB7JpJ0tAfujtnNyQ=";
    target_map = ";;u-boot.bin-rtd1619b_emmc rtd1619b_emmc_bind_4gb.bin";
  };
}
