{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "nanopineoplus2";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "nanopi_neo_plus2_defconfig";
  };
}
