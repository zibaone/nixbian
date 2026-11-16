{ platforms, lib }:
lib.recursiveUpdate platforms."filogic-current" {
  board = "bananapir4";
  dtb = "mediatek/mt7988a-bananapi-bpi-r4-sd.dtb";
  family = "filogic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
