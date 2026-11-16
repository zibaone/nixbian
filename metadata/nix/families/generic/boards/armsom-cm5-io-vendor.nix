{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "armsom-cm5-io";
  dtb = "rockchip/rk3576-armsom-cm5-io.dtb";
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
