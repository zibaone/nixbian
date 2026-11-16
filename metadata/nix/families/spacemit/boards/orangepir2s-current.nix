{ platforms, lib }: lib.recursiveUpdate platforms."spacemit-current" {
  board = "orangepir2s";
  dtb = "spacemit/k1-orangepi-r2s.dtb";
  family = "spacemit";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
