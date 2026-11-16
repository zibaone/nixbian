{
  "arm64-cloud" = {
    arch = "arm64";
    branch = "cloud";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-arm64-cloud";
      config_path = "config/kernel/linux-uefi-arm64-cloud.config";
      config_path_nix = "configs/linux-uefi-arm64-cloud.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-arm64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-arm64-7.0";
      patches = [
        "patches/kernel/archive/uefi-arm64-7.0/1000-net-stmicro-stmmac-Phytium-onboard-ethernet-drivers-and-ACPI-glue-for-6.x.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1001-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-remove-axi_blen-array.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1002-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-replace-has_xxxx-with-core_type.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1003-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-pass-struct-device-to-init-exit-methods.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1004-fix-stmmac-compilation-warnings.patch"
        "patches/kernel/archive/uefi-arm64-7.0/board-hikey960-usb.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "arm64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-arm64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "arm64-current" = {
    arch = "arm64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-arm64-current";
      config_path = "config/kernel/linux-uefi-arm64-current.config";
      config_path_nix = "configs/linux-uefi-arm64-current.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-arm64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-arm64-7.0";
      patches = [
        "patches/kernel/archive/uefi-arm64-7.0/1000-net-stmicro-stmmac-Phytium-onboard-ethernet-drivers-and-ACPI-glue-for-6.x.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1001-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-remove-axi_blen-array.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1002-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-replace-has_xxxx-with-core_type.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1003-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-pass-struct-device-to-init-exit-methods.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1004-fix-stmmac-compilation-warnings.patch"
        "patches/kernel/archive/uefi-arm64-7.0/board-hikey960-usb.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "arm64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-arm64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "arm64-edge" = {
    arch = "arm64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-arm64-edge";
      config_path = "config/kernel/linux-uefi-arm64-edge.config";
      config_path_nix = "configs/linux-uefi-arm64-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-arm64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-arm64-7.0";
      patches = [
        "patches/kernel/archive/uefi-arm64-7.0/1000-net-stmicro-stmmac-Phytium-onboard-ethernet-drivers-and-ACPI-glue-for-6.x.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1001-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-remove-axi_blen-array.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1002-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-replace-has_xxxx-with-core_type.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1003-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-pass-struct-device-to-init-exit-methods.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1004-fix-stmmac-compilation-warnings.patch"
        "patches/kernel/archive/uefi-arm64-7.0/board-hikey960-usb.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "arm64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-arm64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "arm64-legacy" = {
    arch = "arm64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-arm64-legacy";
      config_path = "config/kernel/linux-uefi-arm64-legacy.config";
      config_path_nix = "configs/linux-uefi-arm64-legacy.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-arm64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-arm64-7.0";
      patches = [
        "patches/kernel/archive/uefi-arm64-7.0/1000-net-stmicro-stmmac-Phytium-onboard-ethernet-drivers-and-ACPI-glue-for-6.x.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1001-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-remove-axi_blen-array.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1002-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-replace-has_xxxx-with-core_type.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1003-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-pass-struct-device-to-init-exit-methods.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1004-fix-stmmac-compilation-warnings.patch"
        "patches/kernel/archive/uefi-arm64-7.0/board-hikey960-usb.patch"
      ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "arm64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-arm64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "arm64-sc8280xp" = {
    arch = "arm64";
    branch = "sc8280xp";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:lenovo-x13s-linux-7.0.y";
      config = "linux-uefi-arm64-sc8280xp";
      config_path = "config/kernel/linux-uefi-arm64-sc8280xp.config";
      exact_version = "7.0.14";
      hash = "sha256-vCGwSplTWTchyA6xcWhornGjr7GpytHwXNAAtMp10AY=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-arm64-branch-lenovo-x13s-linux-7-0-y";
      patch_dir = "archive/uefi-arm64-7.0";
      patches = [
        "patches/kernel/archive/uefi-arm64-7.0/1000-net-stmicro-stmmac-Phytium-onboard-ethernet-drivers-and-ACPI-glue-for-6.x.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1001-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-remove-axi_blen-array.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1002-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-replace-has_xxxx-with-core_type.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1003-net-stmicro-stmmac-Phytium-adapt-to-net-stmmac-pass-struct-device-to-init-exit-methods.patch"
        "patches/kernel/archive/uefi-arm64-7.0/1004-fix-stmmac-compilation-warnings.patch"
        "patches/kernel/archive/uefi-arm64-7.0/board-hikey960-usb.patch"
      ];
      source = "https://github.com/steev/linux.git";
    };
    linux_family = "arm64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-arm64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
}
