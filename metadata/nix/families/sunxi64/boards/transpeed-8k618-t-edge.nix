{ platforms, lib }: lib.recursiveUpdate platforms."sunxi64-edge" {
  board = "transpeed-8k618-t";
  dtb = "allwinner/sun50i-h618-transpeed-8k618-t.dtb";
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
