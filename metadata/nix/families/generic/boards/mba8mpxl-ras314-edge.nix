{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "mba8mpxl-ras314";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "tqma8mpxl_multi_mba8mp_ras314_defconfig";
  };
}
