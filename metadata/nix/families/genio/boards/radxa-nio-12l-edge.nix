{ platforms, lib }:
lib.recursiveUpdate platforms."genio-edge" {
  board = "radxa-nio-12l";
  dtb = "mediatek/mt8395-radxa-nio-12l.dtb";
  family = "genio";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
