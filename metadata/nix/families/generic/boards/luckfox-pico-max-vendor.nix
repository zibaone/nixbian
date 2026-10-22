{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "luckfox-pico-max";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    patch_dir = "rv1106-vendor-6.1";
    patches = [ ];
  };
  kernel_params = null;
  uboot = {
    branch = "branch:next-dev-buildroot";
    config = "luckfox_rv1106_uboot_defconfig";
    nvfetcher_key = "uboot-branch-next-dev-buildroot";
    patch_dir = "legacy/u-boot-rockchip-buildroot";
    patches = [
      "patches/uboot/legacy/u-boot-rockchip-buildroot/fix-source-cmd.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-bootscr.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-malloc_8_hide_optee.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/rv1103-rv1106-mem_layout.patch"
      "patches/uboot/legacy/u-boot-rockchip-buildroot/use-armv7a-for-modern-toolchain.patch"
    ];
    source_hash = "sha256-Jdtw6Q/DZjYzQsICTYsn/QUS8OnnyAQbBa2tztlv8dM=";
    target_map = "spl/u-boot-spl.bin u-boot.dtb u-boot-nodtb.bin;;download.bin idblock.img u-boot.itb";
  };
}
