{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "lepotato";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2024.01";
    config = "libretech-cc_defconfig";
    nvfetcher_key = "uboot-tag-v2024-01";
    patch_dir = "v2024.01";
    patches = [
      "patches/uboot/v2024.01/board_lepotato/le-potato-general-vendor.patch"
      "patches/uboot/v2024.01/board_nanopik2-s905/add-emmc-support-for-nanopi-k2.patch"
      "patches/uboot/v2024.01/board_orangepi5/0010-Fix-SPI-Boot.patch"
      "patches/uboot/v2024.01/general-btrfs-fix-out-of-bounds-write.patch"
      "patches/uboot/v2024.01/general-btrfs-fix-reading-when-length-specified.patch"
    ];
    source_hash = "sha256-0Da7Czy9cpQ+D5EICc3/QSZhAdCBsmeMvBgykYhAQFw=";
    target_map = ";;packages/blobs/meson/u-boot-vim2-sd.bin:u-boot.bin";
  };
}
