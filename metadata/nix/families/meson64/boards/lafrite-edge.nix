{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "lafrite";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "libretech-ac_defconfig";
    target_map = ";;packages/blobs/meson/u-boot-vim2-sd.bin:u-boot.bin";
  };
}
