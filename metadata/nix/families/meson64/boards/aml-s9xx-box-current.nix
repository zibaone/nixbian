{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "aml-s9xx-box";
  dtb = "amlogic/meson-gxl-s905x-p212.dtb";
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "none";
    target_map = ";;packages/blobs/meson/u-boot-vim2-sd.bin:u-boot.bin";
  };
}
