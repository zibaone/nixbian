{
  "spacemit-current" = {
    arch = "riscv64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-spacemit-edge";
      config_path = "config/kernel/linux-spacemit-edge.config";
      config_path_nix = "configs/linux-spacemit-edge.config";
      exact_version = "6.18.37";
      hash = "sha256-n6Ek5cTBRXWIGRrpFchTqzGSfhDWLgjaVbWASqp5x8M=";
      major_minor = "7.1";
      nvfetcher_key = "kernel-spacemit-branch-linux-6-18-y";
      patch_dir = "archive/spacemit-7.1";
      patches = [
        "patches/kernel/archive/spacemit-7.1/001-PATCH-v2-0-2-cpufreq-spacemit-Add-cpufreq-support-for-K1-SoC.patch"
        "patches/kernel/archive/spacemit-7.1/002-PATCH-v2-0-4-spacemit-k1-bananapi-f3-Fix-the-power-source-of-USB3-nodes.patch"
        "patches/kernel/archive/spacemit-7.1/003-PATCH-v5-0-3-thermal-spacemit-Add-support-for-SpacemiT-K1-SoC-thermal-sensor.patch"
        "patches/kernel/archive/spacemit-7.1/004-PATCH-v5-2-2-mfd-simple-mfd-i2c-add-a-reboot-cell-for-the-SpacemiT-P1-chip.patch"
        "patches/kernel/archive/spacemit-7.1/005-PATCH-v8-0-9-riscv-spacemit-enable-SD-card-support-with-UHS-modes-for-OrangePi-RV2.patch"
        "patches/kernel/archive/spacemit-7.1/006-PATCH-v2-riscv-mm-fix-SWIOTLB-initialization-for-systems-with-DRAM-above-4GB.patch"
        "patches/kernel/archive/spacemit-7.1/008-PATCH-v9-0-3-spi-support-the-SpacemiT-K1-SPI-controller.patch"
        "patches/kernel/archive/spacemit-7.1/050-Update-Milk-V-Jupiter-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/051-Update-MusePi-Pro-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/052-OrangePi-RV2-R2S-add-sdcard-and-emmc.patch"
        "patches/kernel/archive/spacemit-7.1/053-Update-BPI-F3-DTS.patch"
      ];
      source = "https://github.com/jmontleon/linux-bianbu.git";
    };
    linux_family = "spacemit";
    uboot = {
      atf_branch = "tag:k1-bl-v2.2.9-release";
      atf_hash = "sha256-Vd/a1gIP3bBqLpmz5HAU6HyrK5SuFDnI2m1T2DrtkwE=";
      atf_nvfetcher_key = "src-spacemit-opensbi-tag-k1-bl-v2-2-9-release";
      atf_platform = null;
      atf_source = "https://github.com/pyavitz/spacemit-opensbi.git";
      atf_target_map = "PLATFORM_DEFCONFIG=k1_defconfig PLATFORM=generic ;;build/platform/generic/firmware/fw_dynamic.itb";
      branch = "tag:k1-bl-v2.2.9-release";
      config = "k1_defconfig";
      nvfetcher_key = "uboot-tag-k1-bl-v2-2-9-release";
      patch_dir = "legacy/u-boot-spacemit-k1";
      patches = [
        "patches/uboot/legacy/u-boot-spacemit-k1/001-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/002-SpacemiT-K1X-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/003-SpacemiT-K1X-Defconfig-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/004-Add-syslinux-script-and-uefi-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/005-Orange-Pi-RV2-u-boot-support-for-XM25QU128C-flash.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/006-orangepi-rv2-r2s-fit.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/007-efi_loader-suppress-error-print-message.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/008-Quiet-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/009-Fixup-circular-deps.patch"
      ];
      source = "https://github.com/pyavitz/spacemit-u-boot.git";
      source_hash = "sha256-hYrA0lwZGn0IfzWp6CGghtPK7c85WG69Upd25ie+vbQ=";
      target_map = ";;bootinfo_emmc.bin bootinfo_spinor.bin FSBL.bin fw_dynamic.itb u-boot.itb u-boot-env-default.bin";
    };
  };
  "spacemit-edge" = {
    arch = "riscv64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-spacemit-edge";
      config_path = "config/kernel/linux-spacemit-edge.config";
      config_path_nix = "configs/linux-spacemit-edge.config";
      exact_version = "6.18.37";
      hash = "sha256-n6Ek5cTBRXWIGRrpFchTqzGSfhDWLgjaVbWASqp5x8M=";
      major_minor = "7.1";
      nvfetcher_key = "kernel-spacemit-branch-linux-6-18-y";
      patch_dir = "archive/spacemit-7.1";
      patches = [
        "patches/kernel/archive/spacemit-7.1/001-PATCH-v2-0-2-cpufreq-spacemit-Add-cpufreq-support-for-K1-SoC.patch"
        "patches/kernel/archive/spacemit-7.1/002-PATCH-v2-0-4-spacemit-k1-bananapi-f3-Fix-the-power-source-of-USB3-nodes.patch"
        "patches/kernel/archive/spacemit-7.1/003-PATCH-v5-0-3-thermal-spacemit-Add-support-for-SpacemiT-K1-SoC-thermal-sensor.patch"
        "patches/kernel/archive/spacemit-7.1/004-PATCH-v5-2-2-mfd-simple-mfd-i2c-add-a-reboot-cell-for-the-SpacemiT-P1-chip.patch"
        "patches/kernel/archive/spacemit-7.1/005-PATCH-v8-0-9-riscv-spacemit-enable-SD-card-support-with-UHS-modes-for-OrangePi-RV2.patch"
        "patches/kernel/archive/spacemit-7.1/006-PATCH-v2-riscv-mm-fix-SWIOTLB-initialization-for-systems-with-DRAM-above-4GB.patch"
        "patches/kernel/archive/spacemit-7.1/008-PATCH-v9-0-3-spi-support-the-SpacemiT-K1-SPI-controller.patch"
        "patches/kernel/archive/spacemit-7.1/050-Update-Milk-V-Jupiter-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/051-Update-MusePi-Pro-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/052-OrangePi-RV2-R2S-add-sdcard-and-emmc.patch"
        "patches/kernel/archive/spacemit-7.1/053-Update-BPI-F3-DTS.patch"
      ];
      source = "https://github.com/jmontleon/linux-bianbu.git";
    };
    linux_family = "spacemit";
    uboot = {
      atf_branch = "tag:k1-bl-v2.2.9-release";
      atf_hash = "sha256-Vd/a1gIP3bBqLpmz5HAU6HyrK5SuFDnI2m1T2DrtkwE=";
      atf_nvfetcher_key = "src-spacemit-opensbi-tag-k1-bl-v2-2-9-release";
      atf_platform = null;
      atf_source = "https://github.com/pyavitz/spacemit-opensbi.git";
      atf_target_map = "PLATFORM_DEFCONFIG=k1_defconfig PLATFORM=generic ;;build/platform/generic/firmware/fw_dynamic.itb";
      branch = "tag:k1-bl-v2.2.9-release";
      config = "k1_defconfig";
      nvfetcher_key = "uboot-tag-k1-bl-v2-2-9-release";
      patch_dir = "legacy/u-boot-spacemit-k1";
      patches = [
        "patches/uboot/legacy/u-boot-spacemit-k1/001-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/002-SpacemiT-K1X-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/003-SpacemiT-K1X-Defconfig-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/004-Add-syslinux-script-and-uefi-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/005-Orange-Pi-RV2-u-boot-support-for-XM25QU128C-flash.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/006-orangepi-rv2-r2s-fit.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/007-efi_loader-suppress-error-print-message.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/008-Quiet-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/009-Fixup-circular-deps.patch"
      ];
      source = "https://github.com/pyavitz/spacemit-u-boot.git";
      source_hash = "sha256-hYrA0lwZGn0IfzWp6CGghtPK7c85WG69Upd25ie+vbQ=";
      target_map = ";;bootinfo_emmc.bin bootinfo_spinor.bin FSBL.bin fw_dynamic.itb u-boot.itb u-boot-env-default.bin";
    };
  };
  "spacemit-legacy" = {
    arch = "riscv64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-6.18.y";
      config = "linux-spacemit-edge";
      config_path = "config/kernel/linux-spacemit-edge.config";
      config_path_nix = "configs/linux-spacemit-edge.config";
      exact_version = "6.18.37";
      hash = "sha256-n6Ek5cTBRXWIGRrpFchTqzGSfhDWLgjaVbWASqp5x8M=";
      major_minor = "7.1";
      nvfetcher_key = "kernel-spacemit-branch-linux-6-18-y";
      patch_dir = "archive/spacemit-7.1";
      patches = [
        "patches/kernel/archive/spacemit-7.1/001-PATCH-v2-0-2-cpufreq-spacemit-Add-cpufreq-support-for-K1-SoC.patch"
        "patches/kernel/archive/spacemit-7.1/002-PATCH-v2-0-4-spacemit-k1-bananapi-f3-Fix-the-power-source-of-USB3-nodes.patch"
        "patches/kernel/archive/spacemit-7.1/003-PATCH-v5-0-3-thermal-spacemit-Add-support-for-SpacemiT-K1-SoC-thermal-sensor.patch"
        "patches/kernel/archive/spacemit-7.1/004-PATCH-v5-2-2-mfd-simple-mfd-i2c-add-a-reboot-cell-for-the-SpacemiT-P1-chip.patch"
        "patches/kernel/archive/spacemit-7.1/005-PATCH-v8-0-9-riscv-spacemit-enable-SD-card-support-with-UHS-modes-for-OrangePi-RV2.patch"
        "patches/kernel/archive/spacemit-7.1/006-PATCH-v2-riscv-mm-fix-SWIOTLB-initialization-for-systems-with-DRAM-above-4GB.patch"
        "patches/kernel/archive/spacemit-7.1/008-PATCH-v9-0-3-spi-support-the-SpacemiT-K1-SPI-controller.patch"
        "patches/kernel/archive/spacemit-7.1/050-Update-Milk-V-Jupiter-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/051-Update-MusePi-Pro-DTS.patch"
        "patches/kernel/archive/spacemit-7.1/052-OrangePi-RV2-R2S-add-sdcard-and-emmc.patch"
        "patches/kernel/archive/spacemit-7.1/053-Update-BPI-F3-DTS.patch"
      ];
      source = "https://github.com/jmontleon/linux-bianbu.git";
    };
    linux_family = "spacemit";
    uboot = {
      atf_branch = "tag:k1-bl-v2.2.9-release";
      atf_hash = "sha256-Vd/a1gIP3bBqLpmz5HAU6HyrK5SuFDnI2m1T2DrtkwE=";
      atf_nvfetcher_key = "src-spacemit-opensbi-tag-k1-bl-v2-2-9-release";
      atf_platform = null;
      atf_source = "https://github.com/pyavitz/spacemit-opensbi.git";
      atf_target_map = "PLATFORM_DEFCONFIG=k1_defconfig PLATFORM=generic ;;build/platform/generic/firmware/fw_dynamic.itb";
      branch = "tag:k1-bl-v2.2.9-release";
      config = "k1_defconfig";
      nvfetcher_key = "uboot-tag-k1-bl-v2-2-9-release";
      patch_dir = "legacy/u-boot-spacemit-k1";
      patches = [
        "patches/uboot/legacy/u-boot-spacemit-k1/001-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/002-SpacemiT-K1X-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/003-SpacemiT-K1X-Defconfig-Fixups.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/004-Add-syslinux-script-and-uefi-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/005-Orange-Pi-RV2-u-boot-support-for-XM25QU128C-flash.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/006-orangepi-rv2-r2s-fit.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/007-efi_loader-suppress-error-print-message.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/008-Quiet-MBR-support.patch"
        "patches/uboot/legacy/u-boot-spacemit-k1/009-Fixup-circular-deps.patch"
      ];
      source = "https://github.com/pyavitz/spacemit-u-boot.git";
      source_hash = "sha256-hYrA0lwZGn0IfzWp6CGghtPK7c85WG69Upd25ie+vbQ=";
      target_map = ";;bootinfo_emmc.bin bootinfo_spinor.bin FSBL.bin fw_dynamic.itb u-boot.itb u-boot-env-default.bin";
    };
  };
}
