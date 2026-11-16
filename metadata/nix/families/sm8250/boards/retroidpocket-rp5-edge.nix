{ platforms, lib }: lib.recursiveUpdate platforms."sm8250-edge" {
  board = "retroidpocket-rp5";
  dtb = "qcom/sm8250-retroidpocket-rp5.dtb";
  family = "sm8250";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
