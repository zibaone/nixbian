{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "aml-t95z-plus";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2024.04";
    config = "meson-gxm-t95z-plus_defconfig";
    nvfetcher_key = "uboot-tag-v2024-04";
    patch_dir = "v2024.04/board_t95z";
    patches = [ ];
    source_hash = "sha256-IlaDdjKq/Pq2orzcU959h93WXRZfvKBGDO/MFw9mZMg=";
    target_map = ";;packages/blobs/meson/u-boot-vim2-sd.bin:u-boot.bin";
  };
}
