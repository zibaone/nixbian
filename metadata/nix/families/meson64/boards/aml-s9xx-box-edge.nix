{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-edge" {
  board = "aml-s9xx-box";
  dtb = null;
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
