{ platforms, lib }:
lib.recursiveUpdate platforms."sunxi-edge" {
  board = "bananapim3";
  dtb = null;
  family = "sunxi";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2024.01";
    config = "Sinovoip_BPI_M3_defconfig";
    nvfetcher_key = "uboot-tag-v2024-01";
    patch_dir = "u-boot-sunxi/board_\${BOARD} u-boot-sunxi-crust";
    patches = [
      "patches/uboot/u-boot-sunxi-crust/h3-h5-fix-pinctrl-err-19.patch"
      "patches/uboot/u-boot-sunxi-crust/h3-scp.patch"
      "patches/uboot/u-boot-sunxi-crust/sunxi-Enable-remoteproc-on-H3.patch"
    ];
    source_hash = "sha256-0Da7Czy9cpQ+D5EICc3/QSZhAdCBsmeMvBgykYhAQFw=";
  };
}
