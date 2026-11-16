{ platforms, lib }: lib.recursiveUpdate platforms."ls1046a-current" {
  board = "gateway-dk";
  dtb = "freescale/mono-gateway-dk.dtb";
  family = "ls1046a";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
