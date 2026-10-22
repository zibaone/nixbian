{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "radxa-zero";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2023.07.02";
    config = "radxa-zero_config";
    nvfetcher_key = "uboot-tag-v2023-07-02";
    patch_dir = "v2023.07.02";
    patches = [
      "patches/uboot/v2023.07.02/board_radxa-zero/001-HACK-fix-meson-mmc-core-phase-in-the-tuning-process.patch"
      "patches/uboot/v2023.07.02/board_radxa-zero/002-configs-radxa-zero_defconfig-enable-preboot.patch"
      "patches/uboot/v2023.07.02/board_radxa-zero/003-configs-radxa-zero_defconfig-reset-board-if-failed-to-boot.patch"
    ];
    source_hash = "sha256-HPBjm/rIkfTCyAKCFvCqoK7oNN9e9rV9l32qLmI/qz4=";
  };
}
