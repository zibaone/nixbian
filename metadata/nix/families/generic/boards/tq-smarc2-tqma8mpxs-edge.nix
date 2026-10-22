{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "tq-smarc2-tqma8mpxs";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "PLAT=imx8mp IMX_BOOT_UART_BASE=0x30880000 bl31;;build/imx8mp/release/bl31.bin";
    config = "tqma8mpxs_multi_mb_smarc_2_defconfig";
  };
}
