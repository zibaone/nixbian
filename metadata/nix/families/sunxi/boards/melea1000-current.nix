{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-current" {
  board = "melea1000";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "Mele_A1000_defconfig";
  };
}
