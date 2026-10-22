{ platforms, lib }:
lib.recursiveUpdate platforms."loong64-edge" {
  board = "uefi-loong64";
  dtb = null;
  family = "loong64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
