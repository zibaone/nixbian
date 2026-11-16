{ platforms, lib }: lib.recursiveUpdate platforms."qrb2210-edge" {
  board = "arduino-uno-q";
  dtb = "qcom/qrb2210-arduino-imola.dtb";
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
