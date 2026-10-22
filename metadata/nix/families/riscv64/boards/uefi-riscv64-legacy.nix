{ platforms, lib }:
lib.recursiveUpdate platforms."riscv64-legacy" {
  board = "uefi-riscv64";
  dtb = null;
  family = "riscv64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
