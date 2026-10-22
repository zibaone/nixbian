{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-legacy" {
  board = "cubieboard2";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Cubieboard2_config";
  };
}
