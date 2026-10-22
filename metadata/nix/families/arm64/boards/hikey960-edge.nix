{ platforms, lib }:
lib.recursiveUpdate platforms."arm64-edge" {
  board = "hikey960";
  dtb = null;
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
