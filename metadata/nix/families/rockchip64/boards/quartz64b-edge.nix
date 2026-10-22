{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "quartz64b";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr quartz64-b-rk3566_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr quartz64-b-rk3566_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2024.07";
    config = "quartz64-b-rk3566_defconfig";
    nvfetcher_key = "uboot-tag-v2024-07";
    patch_dir = "v2024.07/board_\${BOARD}";
    source_hash = "sha256-mJ2TBy0Y5ZtcGFgtU5RKr0UDUp5FWzojbFb+o/ebRJU=";
  };
}
