{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "cubieboard";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Cubieboard_config";
  };
}
