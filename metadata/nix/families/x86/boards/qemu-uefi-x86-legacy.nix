{ platforms, lib }:
lib.recursiveUpdate platforms."x86-legacy" {
  board = "qemu-uefi-x86";
  dtb = null;
  family = "x86";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
