{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "tinkerboard";
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
    branch = "commit:0b8e25bd9e16e8043b600e8f49b926b95572dc47";
    config = "tinker-s-rk3288_defconfig";
    nvfetcher_key = "uboot-commit-0b8e25bd9e16e8043b600e8f49b926b95572dc47";
    patch_dir = "u-boot-rk3506";
    patches = [ "patches/uboot/u-boot-rk3506/forge1-btrfs.patch" ];
    source = "https://source.denx.de/u-boot/contributors/kwiboo/u-boot.git";
    source_hash = "sha256-WqIPm/wzNAEe8UoqzmEefuv6qY4IfxIZ/DEuYA2MNpI=";
    target_map = "ROCKCHIP_TPL=cache/sources/rkbin-tools/rk35/rk3506_ddr_750MHz_v1.06.bin TEE=cache/sources/rkbin-tools/rk35/rk3506_tee_v2.10.bin;;u-boot-rockchip.bin";
  };
}
