{ platforms, lib }: lib.recursiveUpdate platforms."sm8250-current" {
  board = "retroidpocket-rpmini";
  dtb = "qcom/sm8250-retroidpocket-rpmini.dtb";
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
