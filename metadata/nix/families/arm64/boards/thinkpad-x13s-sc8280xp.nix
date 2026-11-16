{ platforms, lib }:
lib.recursiveUpdate platforms."arm64-sc8280xp" {
  board = "thinkpad-x13s";
  dtb = "qcom/sc8280xp-lenovo-thinkpad-x13s.dtb";
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
