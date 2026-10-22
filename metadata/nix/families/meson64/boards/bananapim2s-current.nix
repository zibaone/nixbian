{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "bananapim2s";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2026.01";
    config = "bananapi-m2s_defconfig";
    nvfetcher_key = "uboot-tag-v2026-01";
    patch_dir = "v2026.01";
    patches = [
      "patches/uboot/v2026.01/0001-pci-pcie_dw_rockchip-increase-PCIe-LTSSM-timeout-for-cold-boot.patch"
      "patches/uboot/v2026.01/add-nanopc-t6-lts-plus-detection.patch"
      "patches/uboot/v2026.01/arm64-dts-allwinner-sun55i-a523-add-pcie-spi-combophy.patch"
      "patches/uboot/v2026.01/board_bananapicm4io/001-BananaPi-CM4-Enable-NVME-PCI-SUPPORT.patch"
      "patches/uboot/v2026.01/board_bananapicm4io/002-BananaPi-CM4-Enable-PREBOOT-and-BOOT-LOGO-support.patch"
      "patches/uboot/v2026.01/board_bananapicm4io/003-BananaPi-CM4-Enable-SATA-BOOT-support.patch"
      "patches/uboot/v2026.01/board_bananapicm4io/004-BananaPi-M2S-Fixup.patch"
      "patches/uboot/v2026.01/board_bananapicm4io/005-BananaPi-M2S-Enable-PREBOOT-and-BOOT-LOGO-support.patch"
      "patches/uboot/v2026.01/board_bananapim4zero/001-Add-board-BananaPi-BPI-M4-Zero.patch"
      "patches/uboot/v2026.01/board_bananapim4zero/002-Add-board-KickPi-K2B.patch"
      "patches/uboot/v2026.01/board_bananapim4zero/010-HACK-sunxi-h616-gpu-enable.patch"
      "patches/uboot/v2026.01/board_bananapim4zero/011-sunxi-h616-ths-workaround.patch"
      "patches/uboot/v2026.01/board_bananapim4zero/012-mach-sunxi-dram_helpers-add-delay-to-steady-dram-detection.patch"
      "patches/uboot/v2026.01/board_bestv-r3300-l/add-board-bestv-r3300-l.patch"
      "patches/uboot/v2026.01/board_cainiao-cniot-core/add-board-cainiao-cniot-core.patch"
      "patches/uboot/v2026.01/board_helios64/1000-exception-include-string.patch"
      "patches/uboot/v2026.01/board_helios64/1001-helios64-enable-target.patch"
      "patches/uboot/v2026.01/board_helios64/general-fix-btrfs-zstd-decompression.patch"
      "patches/uboot/v2026.01/board_khadas-vim3l/kvim3l-boot-usb-sata-sd.patch"
      "patches/uboot/v2026.01/board_mixtile-core3588e/1001-fdt_fixup_ethernet-add-logs.patch"
      "patches/uboot/v2026.01/board_norco-emb-3531/add-board-norco-emb-3531.patch"
      "patches/uboot/v2026.01/board_orangepi-4a/arm64-dts-sun55i-t527-orangepi-4a-enable-spi0-pcie-combophy.patch"
      "patches/uboot/v2026.01/board_orangepi-4a/edit-orangepi-4a-defconfig.patch"
      "patches/uboot/v2026.01/board_orangepi3-lts/001-Add-board-OrangePi-3-LTS.patch"
      "patches/uboot/v2026.01/board_orangepi3-lts/002-Add-OrangePi-3-LTS-defconfig.patch"
      "patches/uboot/v2026.01/board_orangepi3-lts/003-mmc-increase-stabilization-delay-from-1ms-to-20ms.patch"
      "patches/uboot/v2026.01/board_orangepi3b/0001-rockchip-rk3566-orangepi-3b-enable-npu-regulator.patch"
      "patches/uboot/v2026.01/board_orangepi3b/0002-rockchip-rk3566-orangepi-3b-remove_download_button.patch"
      "patches/uboot/v2026.01/board_orangepi3b/0003-rk3566-orangepi-3b-enable-boot-from-sata.patch"
      "patches/uboot/v2026.01/board_radxa-cubie-a5e/arm64-dts-sun55i-a527-cubie-a5e-enable-spi0-pcie-combophy.patch"
      "patches/uboot/v2026.01/board_radxa-cubie-a5e/edit-radxa-cubie-a5e-defconfig.patch"
      "patches/uboot/v2026.01/board_radxa-e24c/9000-rockchip-rk3528-Add-support-for-booting-from-SPI-fla.patch"
      "patches/uboot/v2026.01/board_radxa-e24c/9001-WIP-net-rockchip-Allow-use-of-rx-tx-delayline-for-rg.patch"
      "patches/uboot/v2026.01/board_radxa-e24c/9002-WIP-net-rockchip-Use-CRU-as-default-TX-clk-source-fo.patch"
      "patches/uboot/v2026.01/board_radxa-e24c/9003-WIP-Kwiboo-s-WIP-rk3528.dtsi-with-pcie-usb-combphy-e.patch"
      "patches/uboot/v2026.01/board_radxa-e24c/9004-WIP-add-e24c-board-model-to-rock-2-rk3528.c.patch"
      "patches/uboot/v2026.01/board_radxa-e52c/0000-add-initial-rk3582-support.patch"
      "patches/uboot/v2026.01/board_radxa-e52c/0001-rk3588-generic-support-for-rk3582.patch"
      "patches/uboot/v2026.01/board_radxa-e52c/1000-add-support-for-radxa-e52c.patch"
      "patches/uboot/v2026.01/board_radxa-zero2/zero2-boot-sd-usb-nvme.patch"
      "patches/uboot/v2026.01/board_smart-am40/add-board-smart-am40.patch"
      "patches/uboot/v2026.01/clk-sunxi-add-sun55i-a523-pcie-usb3-clocks.patch"
      "patches/uboot/v2026.01/cmd-fileenv-read-string-from-file-into-env.patch"
      "patches/uboot/v2026.01/pcie-sunxi-add-dw-pcie-support-for-sun55i.patch"
      "patches/uboot/v2026.01/phy-allwinner-add-pcie-usb3-driver.patch"
      "patches/uboot/v2026.01/spi-sunxi-add-sun55i-a523-spl-support.patch"
      "patches/uboot/v2026.01/spi-sunxi-add-sun55i-a523-support.patch"
      "patches/uboot/v2026.01/sunxi-add-nvme-boot-target.patch"
    ];
    source_hash = "sha256-X3dH6CvXqPuD8crFC/vL9LZcfFckhRXcgVg+YMoSmsU=";
  };
}
