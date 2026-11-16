{ platforms, lib }:
lib.recursiveUpdate platforms."arm64-current" {
  board = "hikey960";
  dtb = "hisilicon/hi3660-hikey960.dtb";
  family = "arm64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
