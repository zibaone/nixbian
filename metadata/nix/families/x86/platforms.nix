{
  "x86-cloud" = {
    arch = "amd64";
    branch = "cloud";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-x86-cloud";
      config_path = "config/kernel/linux-uefi-x86-cloud.config";
      config_path_nix = "configs/linux-uefi-x86-cloud.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-x86-branch-linux-7-0-y";
      patch_dir = "archive/uefi-x86-7.0";
      patches = [
        "patches/kernel/archive/uefi-x86-7.0/1001-Add-apple-bce-driver.patch"
        "patches/kernel/archive/uefi-x86-7.0/1002-Put-apple-bce-in-drivers-staging.patch"
        "patches/kernel/archive/uefi-x86-7.0/1003-Fix-freezing-on-turning-off-camera.patch"
        "patches/kernel/archive/uefi-x86-7.0/2008-i915-4-lane-quirk-for-mbp15-1.patch"
        "patches/kernel/archive/uefi-x86-7.0/2009-apple-gmux-allow-switching-to-igpu-at-probe.patch"
        "patches/kernel/archive/uefi-x86-7.0/3001-applesmc-convert-static-structures-to-drvdata.patch"
        "patches/kernel/archive/uefi-x86-7.0/3002-applesmc-make-io-port-base-addr-dynamic.patch"
        "patches/kernel/archive/uefi-x86-7.0/3003-applesmc-switch-to-acpi_device-from-platform.patch"
        "patches/kernel/archive/uefi-x86-7.0/3004-applesmc-key-interface-wrappers.patch"
        "patches/kernel/archive/uefi-x86-7.0/3005-applesmc-basic-mmio-interface-implementation.patch"
        "patches/kernel/archive/uefi-x86-7.0/3006-applesmc-fan-support-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch"
        "patches/kernel/archive/uefi-x86-7.0/3008-applesmc-make-applesmc_remove-void.patch"
        "patches/kernel/archive/uefi-x86-7.0/3009-applesmc-battery-charge-limiter.patch"
        "patches/kernel/archive/uefi-x86-7.0/4001-asahi-trackpad.patch"
        "patches/kernel/archive/uefi-x86-7.0/4003-HID-apple-ignore-the-trackpad-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/4004-HID-magicmouse-Add-support-for-trackpads-found-on-T2.patch"
        "patches/kernel/archive/uefi-x86-7.0/4005-HID-magicmouse-fix-regression-breaking-support-for-M.patch"
        "patches/kernel/archive/uefi-x86-7.0/7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "x86";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-x86";
      patches = [
        "patches/uboot/u-boot-qemu-x86/0001-hack-higher-ramdisk-load-address-both-in-u-boot-source-and-bootscript.patch"
        "patches/uboot/u-boot-qemu-x86/0002-x86-patch-uboot-defconfig-to-use-the-q35-machine-type-not-i440fx.patch"
        "patches/uboot/u-boot-qemu-x86/0003-hack-bump-bzimage-max-size-to-45mb-from-15mb.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "x86-current" = {
    arch = "amd64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-x86-current";
      config_path = "config/kernel/linux-uefi-x86-current.config";
      config_path_nix = "configs/linux-uefi-x86-current.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-x86-branch-linux-7-0-y";
      patch_dir = "archive/uefi-x86-7.0";
      patches = [
        "patches/kernel/archive/uefi-x86-7.0/1001-Add-apple-bce-driver.patch"
        "patches/kernel/archive/uefi-x86-7.0/1002-Put-apple-bce-in-drivers-staging.patch"
        "patches/kernel/archive/uefi-x86-7.0/1003-Fix-freezing-on-turning-off-camera.patch"
        "patches/kernel/archive/uefi-x86-7.0/2008-i915-4-lane-quirk-for-mbp15-1.patch"
        "patches/kernel/archive/uefi-x86-7.0/2009-apple-gmux-allow-switching-to-igpu-at-probe.patch"
        "patches/kernel/archive/uefi-x86-7.0/3001-applesmc-convert-static-structures-to-drvdata.patch"
        "patches/kernel/archive/uefi-x86-7.0/3002-applesmc-make-io-port-base-addr-dynamic.patch"
        "patches/kernel/archive/uefi-x86-7.0/3003-applesmc-switch-to-acpi_device-from-platform.patch"
        "patches/kernel/archive/uefi-x86-7.0/3004-applesmc-key-interface-wrappers.patch"
        "patches/kernel/archive/uefi-x86-7.0/3005-applesmc-basic-mmio-interface-implementation.patch"
        "patches/kernel/archive/uefi-x86-7.0/3006-applesmc-fan-support-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch"
        "patches/kernel/archive/uefi-x86-7.0/3008-applesmc-make-applesmc_remove-void.patch"
        "patches/kernel/archive/uefi-x86-7.0/3009-applesmc-battery-charge-limiter.patch"
        "patches/kernel/archive/uefi-x86-7.0/4001-asahi-trackpad.patch"
        "patches/kernel/archive/uefi-x86-7.0/4003-HID-apple-ignore-the-trackpad-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/4004-HID-magicmouse-Add-support-for-trackpads-found-on-T2.patch"
        "patches/kernel/archive/uefi-x86-7.0/4005-HID-magicmouse-fix-regression-breaking-support-for-M.patch"
        "patches/kernel/archive/uefi-x86-7.0/7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "x86";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "qemu-x86_defconfig";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-x86";
      patches = [
        "patches/uboot/u-boot-qemu-x86/0001-hack-higher-ramdisk-load-address-both-in-u-boot-source-and-bootscript.patch"
        "patches/uboot/u-boot-qemu-x86/0002-x86-patch-uboot-defconfig-to-use-the-q35-machine-type-not-i440fx.patch"
        "patches/uboot/u-boot-qemu-x86/0003-hack-bump-bzimage-max-size-to-45mb-from-15mb.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = "all;;u-boot.rom";
    };
  };
  "x86-edge" = {
    arch = "amd64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-x86-edge";
      config_path = "config/kernel/linux-uefi-x86-edge.config";
      config_path_nix = "configs/linux-uefi-x86-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-x86-branch-linux-7-0-y";
      patch_dir = "archive/uefi-x86-7.0";
      patches = [
        "patches/kernel/archive/uefi-x86-7.0/1001-Add-apple-bce-driver.patch"
        "patches/kernel/archive/uefi-x86-7.0/1002-Put-apple-bce-in-drivers-staging.patch"
        "patches/kernel/archive/uefi-x86-7.0/1003-Fix-freezing-on-turning-off-camera.patch"
        "patches/kernel/archive/uefi-x86-7.0/2008-i915-4-lane-quirk-for-mbp15-1.patch"
        "patches/kernel/archive/uefi-x86-7.0/2009-apple-gmux-allow-switching-to-igpu-at-probe.patch"
        "patches/kernel/archive/uefi-x86-7.0/3001-applesmc-convert-static-structures-to-drvdata.patch"
        "patches/kernel/archive/uefi-x86-7.0/3002-applesmc-make-io-port-base-addr-dynamic.patch"
        "patches/kernel/archive/uefi-x86-7.0/3003-applesmc-switch-to-acpi_device-from-platform.patch"
        "patches/kernel/archive/uefi-x86-7.0/3004-applesmc-key-interface-wrappers.patch"
        "patches/kernel/archive/uefi-x86-7.0/3005-applesmc-basic-mmio-interface-implementation.patch"
        "patches/kernel/archive/uefi-x86-7.0/3006-applesmc-fan-support-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch"
        "patches/kernel/archive/uefi-x86-7.0/3008-applesmc-make-applesmc_remove-void.patch"
        "patches/kernel/archive/uefi-x86-7.0/3009-applesmc-battery-charge-limiter.patch"
        "patches/kernel/archive/uefi-x86-7.0/4001-asahi-trackpad.patch"
        "patches/kernel/archive/uefi-x86-7.0/4003-HID-apple-ignore-the-trackpad-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/4004-HID-magicmouse-Add-support-for-trackpads-found-on-T2.patch"
        "patches/kernel/archive/uefi-x86-7.0/4005-HID-magicmouse-fix-regression-breaking-support-for-M.patch"
        "patches/kernel/archive/uefi-x86-7.0/7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "x86";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "qemu-x86_defconfig";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-x86";
      patches = [
        "patches/uboot/u-boot-qemu-x86/0001-hack-higher-ramdisk-load-address-both-in-u-boot-source-and-bootscript.patch"
        "patches/uboot/u-boot-qemu-x86/0002-x86-patch-uboot-defconfig-to-use-the-q35-machine-type-not-i440fx.patch"
        "patches/uboot/u-boot-qemu-x86/0003-hack-bump-bzimage-max-size-to-45mb-from-15mb.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = "all;;u-boot.rom";
    };
  };
  "x86-legacy" = {
    arch = "amd64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-x86-legacy";
      config_path = "config/kernel/linux-uefi-x86-legacy.config";
      config_path_nix = "configs/linux-uefi-x86-legacy.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-x86-branch-linux-7-0-y";
      patch_dir = "archive/uefi-x86-7.0";
      patches = [
        "patches/kernel/archive/uefi-x86-7.0/1001-Add-apple-bce-driver.patch"
        "patches/kernel/archive/uefi-x86-7.0/1002-Put-apple-bce-in-drivers-staging.patch"
        "patches/kernel/archive/uefi-x86-7.0/1003-Fix-freezing-on-turning-off-camera.patch"
        "patches/kernel/archive/uefi-x86-7.0/2008-i915-4-lane-quirk-for-mbp15-1.patch"
        "patches/kernel/archive/uefi-x86-7.0/2009-apple-gmux-allow-switching-to-igpu-at-probe.patch"
        "patches/kernel/archive/uefi-x86-7.0/3001-applesmc-convert-static-structures-to-drvdata.patch"
        "patches/kernel/archive/uefi-x86-7.0/3002-applesmc-make-io-port-base-addr-dynamic.patch"
        "patches/kernel/archive/uefi-x86-7.0/3003-applesmc-switch-to-acpi_device-from-platform.patch"
        "patches/kernel/archive/uefi-x86-7.0/3004-applesmc-key-interface-wrappers.patch"
        "patches/kernel/archive/uefi-x86-7.0/3005-applesmc-basic-mmio-interface-implementation.patch"
        "patches/kernel/archive/uefi-x86-7.0/3006-applesmc-fan-support-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch"
        "patches/kernel/archive/uefi-x86-7.0/3008-applesmc-make-applesmc_remove-void.patch"
        "patches/kernel/archive/uefi-x86-7.0/3009-applesmc-battery-charge-limiter.patch"
        "patches/kernel/archive/uefi-x86-7.0/4001-asahi-trackpad.patch"
        "patches/kernel/archive/uefi-x86-7.0/4003-HID-apple-ignore-the-trackpad-on-T2-Macs.patch"
        "patches/kernel/archive/uefi-x86-7.0/4004-HID-magicmouse-Add-support-for-trackpads-found-on-T2.patch"
        "patches/kernel/archive/uefi-x86-7.0/4005-HID-magicmouse-fix-regression-breaking-support-for-M.patch"
        "patches/kernel/archive/uefi-x86-7.0/7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "x86";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-x86";
      patches = [
        "patches/uboot/u-boot-qemu-x86/0001-hack-higher-ramdisk-load-address-both-in-u-boot-source-and-bootscript.patch"
        "patches/uboot/u-boot-qemu-x86/0002-x86-patch-uboot-defconfig-to-use-the-q35-machine-type-not-i440fx.patch"
        "patches/uboot/u-boot-qemu-x86/0003-hack-bump-bzimage-max-size-to-45mb-from-15mb.patch"
      ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
}
