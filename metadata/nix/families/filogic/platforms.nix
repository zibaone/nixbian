{
  "filogic-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:6.12-main";
      config = "linux-filogic-current";
      config_path = "config/kernel/linux-filogic-current.config";
      config_path_nix = "configs/linux-filogic-current.config";
      exact_version = "6.12.82";
      hash = "sha256-5ohqBf56qw1zPn+tTQRPKRJtMdjutrDR1Df6h3KWvXs=";
      major_minor = "6.12";
      nvfetcher_key = "kernel-filogic-branch-6-12-main";
      patch_dir = "archive/filogic-6.12";
      patches = [
        "patches/kernel/archive/filogic-6.12/patches.armbian/mt7988a-bananapi-bpi-r4-sd.patch"
      ];
      source = "https://github.com/frank-w/BPI-Router-Linux.git";
    };
    linux_family = "filogic";
    uboot = {
      atf_branch = "branch:mtksoc-20250212";
      atf_hash = "sha256-WE0b1a6jBmiWbrp44KrsgfJoOESBFGKh3tWSaLU1JOQ=";
      atf_nvfetcher_key = "src-arm-trusted-firmware-branch-mtksoc-20250212";
      atf_platform = null;
      atf_source = "https://github.com/mtk-openwrt/arm-trusted-firmware.git";
      atf_target_map = "PLAT=mt7988 BOOT_DEVICE=sdmmc USE_MKIMAGE=1 BOARD_BGA=1 HAVE_DRAM_OBJ_FILE=yes DRAM_USE_COMB=1 all;;build/mt7988/release/bl2.img build/mt7988/release/bl31.bin";
      branch = "tag:v2022.07";
      config = "mt7988a_bananapi_bpi-r4-sdmmc_defconfig";
      nvfetcher_key = "uboot-tag-v2022-07";
      patch_dir = "u-boot-filogic";
      patches = [
        "patches/uboot/u-boot-filogic/100-02-drivers-mtd-add-support-for-MediaTek-SPI-NAND-flash-.patch"
        "patches/uboot/u-boot-filogic/100-03-mtd-mtk-snand-add-support-for-SPL.patch"
        "patches/uboot/u-boot-filogic/100-04-env-add-support-for-generic-MTD-device.patch"
        "patches/uboot/u-boot-filogic/100-05-mtd-add-a-new-mtd-device-type-for-NMBM.patch"
        "patches/uboot/u-boot-filogic/100-06-mtd-add-core-facility-code-of-NMBM.patch"
        "patches/uboot/u-boot-filogic/100-07-mtd-nmbm-add-support-for-mtd.patch"
        "patches/uboot/u-boot-filogic/100-08-common-board_r-add-support-to-initialize-NMBM-after-.patch"
        "patches/uboot/u-boot-filogic/100-09-cmd-add-nmbm-command.patch"
        "patches/uboot/u-boot-filogic/100-10-cmd-mtd-add-markbad-subcommand-for-NMBM-testing.patch"
        "patches/uboot/u-boot-filogic/100-11-env-add-support-for-NMBM-upper-MTD-layer.patch"
        "patches/uboot/u-boot-filogic/100-12-mtd-mtk-snand-add-NMBM-support-for-SPL.patch"
        "patches/uboot/u-boot-filogic/100-13-cmd-add-a-new-command-for-NAND-flash-debugging.patch"
        "patches/uboot/u-boot-filogic/100-14-mtd-spi-nor-add-support-to-read-flash-unique-ID.patch"
        "patches/uboot/u-boot-filogic/100-15-cmd-sf-add-support-to-read-flash-unique-ID.patch"
        "patches/uboot/u-boot-filogic/100-17-common-spl-spl_nand-enable-CONFIG_SYS_NAND_U_BOOT_OF.patch"
        "patches/uboot/u-boot-filogic/100-21-mtd-spi-nor-add-more-flash-ids.patch"
        "patches/uboot/u-boot-filogic/100-22-mtd-spi-nand-backport-from-upstream-kernel.patch"
        "patches/uboot/u-boot-filogic/100-23-mmc-mtk-sd-add-support-to-display-verbose-error-log.patch"
        "patches/uboot/u-boot-filogic/100-24-cmd-ubi-make-volume-find-create-remove-APIs-public.patch"
        "patches/uboot/u-boot-filogic/100-25-cmd-ubi-allow-creating-volume-with-all-free-spaces.patch"
        "patches/uboot/u-boot-filogic/100-26-env-ubi-add-support-to-create-environment-volume-if-.patch"
        "patches/uboot/u-boot-filogic/100-27-mtd-ubi-add-support-for-UBI-end-of-filesystem-marker.patch"
        "patches/uboot/u-boot-filogic/100-29-board-mediatek-wire-up-NMBM-support.patch"
        "patches/uboot/u-boot-filogic/101-01-mtd-spinand-add-support-for-FORESEE-F35SQA002G.patch"
        "patches/uboot/u-boot-filogic/101-02-mtd-spinand-add-support-for-FORESEE-F35SQA001G.patch"
        "patches/uboot/u-boot-filogic/101-03-mtd-spinand-fix-support-for-FORESEE.patch"
        "patches/uboot/u-boot-filogic/103-04-mt7988-enable-pstore.patch"
        "patches/uboot/u-boot-filogic/105-configs-add-usefull-stuff-to-mt7988-rfb.patch"
        "patches/uboot/u-boot-filogic/120-use-xz-instead-of-lzma.patch"
        "patches/uboot/u-boot-filogic/130-fix-mkimage-host-build.patch"
        "patches/uboot/u-boot-filogic/160-net-phy-add-support-for-Airoha-ethernet-PHY-driver.patch"
        "patches/uboot/u-boot-filogic/170-cmd-bootmenu-permit-to-select-bootmenu-entry-with.patch"
        "patches/uboot/u-boot-filogic/200-cmd-add-imsz-and-imszb.patch"
        "patches/uboot/u-boot-filogic/211-cmd-bootmenu-custom-title.patch"
        "patches/uboot/u-boot-filogic/220-cmd-env-readmem.patch"
        "patches/uboot/u-boot-filogic/230-cmd-add-pstore-check.patch"
        "patches/uboot/u-boot-filogic/250-fix-mmc-erase-timeout.patch"
        "patches/uboot/u-boot-filogic/280-image-fdt-save-name-of-FIT-configuration-in-chosen-node.patch"
        "patches/uboot/u-boot-filogic/305-mt7988-generic-reset-button-ignore-env.patch"
        "patches/uboot/u-boot-filogic/310-mt7988-select-rootdisk.patch"
        "patches/uboot/u-boot-filogic/341-mtd-spinand-Support-dosilicon.patch"
        "patches/uboot/u-boot-filogic/342-mtd-spinand-Support-fmsh.patch"
        "patches/uboot/u-boot-filogic/343-mtd-spinand-gsto-Add-code.patch"
        "patches/uboot/u-boot-filogic/450-add-bpi-r4.patch"
        "patches/uboot/u-boot-filogic/500-add-distro-boot-support.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-1EONRmYLsD0uxo+kpE6mLIYkYMU09Yt0EvSbHhj5prw=";
      target_map = ";;u-boot.bin u-boot_sdmmc.fip bl2.img";
    };
  };
}
