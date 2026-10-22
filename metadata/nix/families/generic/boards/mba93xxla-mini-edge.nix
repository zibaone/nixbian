{ platforms, lib }:
lib.recursiveUpdate platforms."generic-edge" {
  board = "mba93xxla-mini";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
    branch = "branch:linux-7.0.y";
    exact_version = "7.0.14";
    hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
    major_minor = "7.1";
    nvfetcher_key = "kernel-generic-branch-linux-7-0-y";
    patch_dir = "archive/\${LINUXFAMILY}-7.1";
  };
  kernel_params = null;
  uboot = {
    atf_platform = "imx93";
    atf_target_map = "PLAT=imx93 IMX_LPUART_BASE=0x44380000 bl31;;build/imx93/release/bl31.bin";
    config = "tqma93xx_mba93xxla_mini_defconfig";
  };
}
