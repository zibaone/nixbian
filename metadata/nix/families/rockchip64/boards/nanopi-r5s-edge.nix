{ platforms, lib }:
lib.recursiveUpdate platforms."rockchip64-edge" {
  board = "nanopi-r5s";
  dtb = null;
  family = "rockchip64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr nanopi-r5s-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr nanopi-r5s-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    branch = "tag:v2022.07";
    config = "nanopi-r5s-rk3568_defconfig";
    nvfetcher_key = "uboot-tag-v2022-07";
    patch_dir = "v2024.04";
    patches = [
      "patches/uboot/v2024.04/board_bananapim4zero/001-Add-board-BananaPi-BPI-M4-Zero.patch"
      "patches/uboot/v2024.04/board_bananapim4zero/002-sunxi-mmc-Improve-reset-procedure.patch"
      "patches/uboot/v2024.04/board_bananapim4zero/003-HACK-sunxi-h616-gpu-enable.patch"
      "patches/uboot/v2024.04/board_bananapim4zero/004-sunxi-h616-ths-workaround.patch"
      "patches/uboot/v2024.04/board_bananapim4zero/005-mach-sunxi-dram_helpers-add-delay-to-steady-dram-detection.patch"
      "patches/uboot/v2024.04/board_bananapim4zero/006-PATCH-sunxi-spl-h616-fix-booting-from-high-MMC-offset.patch"
      "patches/uboot/v2024.04/board_nanopi-r5s/0001-rockchip-common-boot-USB-devices-first-then-nvme-mmc-s-scsi.patch"
      "patches/uboot/v2024.04/board_nanopi-r5s/0002-usb-otg-mode.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/001-allwinner-common-enable-autoboot-keyed.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/002-allwinner-common-boot-splash.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/003-allwinner-common-h616-THS-workaround.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/004-allwinner-common-h616-GPU-enable-hack.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/005-allwinner-common-pwrled-config-option.patch"
      "patches/uboot/v2024.04/board_orangepizero2w/006-allwinner-common-fdt-setprop-fix-unaligned-access.patch"
      "patches/uboot/v2024.04/board_turing-rk1/0001-include-turing-rk1-rk3588-define-boot-targets.patch"
      "patches/uboot/v2024.04/board_turing-rk1/0002-arm-dts-rk3588-turing-rk1-fix-pcie3x4-hang.patch"
      "patches/uboot/v2024.04/general-btrfs-fix-out-of-bounds-write.patch"
    ];
    source = "https://github.com/u-boot/u-boot";
    source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
  };
}
