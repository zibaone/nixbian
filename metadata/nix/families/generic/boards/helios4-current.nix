{ platforms, lib }:
lib.recursiveUpdate platforms."generic-current" {
  board = "helios4";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "branch:v2018.01-solidrun-a38x";
    config = "helios4_defconfig";
    nvfetcher_key = "uboot-branch-v2018-01-solidrun-a38x";
    patch_dir = "legacy/u-boot-clearfog";
    patches = [
      "patches/uboot/legacy/u-boot-clearfog/0001-fixing-dtc-error.patch"
      "patches/uboot/legacy/u-boot-clearfog/add-boot-marvell.cmd-backward-compatibility.patch"
      "patches/uboot/legacy/u-boot-clearfog/arm-mvebu-add-rev-id-a38x-b0.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogbase/do_pcie_reset_during_init.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogbase/enable_base_model.patch"
      "patches/uboot/legacy/u-boot-clearfog/board_clearfogpro/do_pcie_reset_during_init.patch"
      "patches/uboot/legacy/u-boot-clearfog/enable-pcie-support.patch"
      "patches/uboot/legacy/u-boot-clearfog/libfdt_fix.patch"
      "patches/uboot/legacy/u-boot-clearfog/swap-sata-serdes-rx.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_mmc/set_default_boot_target_to_mmc.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_sata/set_default_boot_target_to_sata.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_sdhc/set_default_boot_target_to_sdhc.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_spi/set_default_boot_target_to_spi.patch"
      "patches/uboot/legacy/u-boot-clearfog/target_uart/set_default_boot_target_to_uart.patch"
      "patches/uboot/legacy/u-boot-clearfog/use-armv7a-for-modern-toolchain.patch"
    ];
    source = "https://github.com/SolidRun/u-boot";
    source_hash = "sha256-lwojtGLrOaBlMI/phBlNgQ0NuA2kfzyh0vXbJLuHlro=";
    target_map = ";sdhc;u-boot-spl-sdhc.kwb:u-boot.mmc";
  };
}
