{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-current" {
  board = "9tripod-x3568-v4";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
