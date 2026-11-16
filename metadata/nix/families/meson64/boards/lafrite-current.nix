{ platforms, lib }: lib.recursiveUpdate platforms."meson64-current" {
  board = "lafrite";
  dtb = "amlogic/meson-gxl-s805x-libretech-ac.dtb";
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
