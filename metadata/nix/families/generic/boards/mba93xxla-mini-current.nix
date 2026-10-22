{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "mba93xxla-mini";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:linux-6.18.y";
    exact_version = "6.18.58";
    hash = "sha256-S48YwJ0smqgblFkpCXNOIY3gRpsmEb8KubAlRjFxBV0=";
    major_minor = "6.18";
    nvfetcher_key = "kernel-generic-branch-linux-6-18-y";
    patch_dir = "archive/\${LINUXFAMILY}-6.18";
  };
  kernel_params = null;
  uboot = {
    atf_platform = "imx93";
    atf_target_map = "PLAT=imx93 IMX_LPUART_BASE=0x44380000 bl31;;build/imx93/release/bl31.bin";
    branch = "tag:v2022.07";
    config = "tqma93xx_mba93xxla_mini_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
    target_map = "flash.bin;;flash.bin";
  };
}
