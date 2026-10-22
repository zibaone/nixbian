{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-legacy" {
  board = "orangepiprime";
  dtb = null;
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "orangepi_prime_defconfig";
  };
}
