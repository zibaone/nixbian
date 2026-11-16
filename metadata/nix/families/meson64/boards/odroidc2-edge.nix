{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "odroidc2";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2022.01";
    config = "odroid-c2_defconfig";
    nvfetcher_key = "uboot-tag-v2022-01";
    patch_dir = "v2022.01";
    patches = [ "patches/uboot/v2022.01/meson64-boot-usb-nvme-scsi-first.patch" ];
    source_hash = "sha256-kKxo62/TI0HD8uZaL39FyJc783JsErkfspKsQ6uvEMU=";
    target_map = ";;cache/sources/amlogic-boot-fip/odroid-c2/bl1.bin.hardkernel u-boot.bin";
  };
}
