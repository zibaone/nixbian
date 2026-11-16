{ platforms, lib }: lib.recursiveUpdate platforms."sunxi64-current" {
  board = "orangepizero3";
  dtb = "allwinner/sun50i-h618-orangepi-zero3.dtb";
  family = "sunxi64";
  firmware = {
  };
  firmware_include = [ "sunxi" "sunxi64" "bt" ];
  kernel = {
  };
  kernel_params = "console=ttyS0,115200";
  uboot = {
    config = "orangepi_zero3_defconfig";
  };
}
