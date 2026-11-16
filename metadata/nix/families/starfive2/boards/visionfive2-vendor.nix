{ platforms, lib }: lib.recursiveUpdate platforms."starfive2-vendor" {
  board = "visionfive2";
  dtb = "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
  family = "starfive2";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
