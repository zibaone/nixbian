{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "tanix-tx6";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_platform = "sun50i_h6";
    atf_target_map = "PLAT=sun50i_h6 DEBUG=1 bl31;;build/sun50i_h6/debug/bl31.bin";
    config = "tanix_tx6_defconfig";
  };
}
