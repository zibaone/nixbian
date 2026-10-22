{ platforms, lib }:
lib.recursiveUpdate platforms."qrb2210-edge" {
  board = "arduino-uno-q";
  dtb = null;
  family = "qrb2210";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
