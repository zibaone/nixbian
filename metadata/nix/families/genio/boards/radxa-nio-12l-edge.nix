{ platforms, lib }:
lib.recursiveUpdate platforms."genio-edge" {
  board = "radxa-nio-12l";
  dtb = null;
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
