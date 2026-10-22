{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "armsom-forge1";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "commit:0b8e25bd9e16e8043b600e8f49b926b95572dc47";
    config = "forge1-rk3506b_defconfig";
    nvfetcher_key = "uboot-commit-0b8e25bd9e16e8043b600e8f49b926b95572dc47";
    patch_dir = "u-boot-rk3506";
    patches = [ "patches/uboot/u-boot-rk3506/forge1-btrfs.patch" ];
    source = "https://source.denx.de/u-boot/contributors/kwiboo/u-boot.git";
    source_hash = "sha256-WqIPm/wzNAEe8UoqzmEefuv6qY4IfxIZ/DEuYA2MNpI=";
    target_map = "ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3506b_ddr_750MHz_v1.06.bin TEE=cache/sources/rkbin-tools/rk35/rk3506_tee_v2.10.bin;;u-boot-rockchip.bin";
  };
}
