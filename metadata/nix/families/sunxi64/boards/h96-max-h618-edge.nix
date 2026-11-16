{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "h96-max-h618";
  dtb = "allwinner/sun50i-h618-h96-max.dtb";
  family = "sunxi64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = "console=ttyS0,115200";
  uboot = {
    config = "transpeed-8k618-t_defconfig";
  };
}
