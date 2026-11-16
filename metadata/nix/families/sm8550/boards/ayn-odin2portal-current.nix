{ platforms, lib }: lib.recursiveUpdate platforms."sm8550-current" {
  board = "ayn-odin2portal";
  dtb = "qcom/qcs8550-\${BOARD}.dtb";
  family = "sm8550";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
