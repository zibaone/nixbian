{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "mba8mpxl";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:linux-\${KERNEL_MAJOR_MINOR}.y";
    nvfetcher_key = "kernel-generic-branch-linux-kernel-major-minor-y";
    patch_dir = "archive/\${LINUXFAMILY}-\${KERNEL_MAJOR_MINOR}";
  };
  kernel_params = null;
  uboot = {
    atf_platform = "imx8mp";
    atf_target_map = "PLAT=imx8mp IMX_BOOT_UART_BASE=0x30a60000 bl31;;build/imx8mp/release/bl31.bin";
    branch = "tag:v2022.07";
    config = "tqma8mpxl_multi_mba8mpxl_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
    target_map = "flash.bin;;flash.bin";
  };
}
