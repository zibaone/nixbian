{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "cubietruck";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Cubietruck_config";
  };
}
