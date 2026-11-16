{ platforms, lib }: lib.recursiveUpdate platforms."spacemit-legacy" {
  board = "musepipro";
  dtb = "spacemit/k1-musepi-pro.dtb";
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
