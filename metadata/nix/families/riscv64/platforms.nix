{
  "riscv64-current" = {
    arch = "riscv64";
    branch = "current";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-riscv64-current";
      config_path = "config/kernel/linux-uefi-riscv64-current.config";
      config_path_nix = "configs/linux-uefi-riscv64-current.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-riscv64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-riscv64-7.0";
      patches = [ ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "riscv64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-riscv64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "riscv64-edge" = {
    arch = "riscv64";
    branch = "edge";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-riscv64-edge";
      config_path = "config/kernel/linux-uefi-riscv64-edge.config";
      config_path_nix = "configs/linux-uefi-riscv64-edge.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-riscv64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-riscv64-7.0";
      patches = [ ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "riscv64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-riscv64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
  "riscv64-legacy" = {
    arch = "riscv64";
    branch = "legacy";
    firmware = {
      branch = "master";
      nvfetcher_key = "src-firmware-master";
      source = "https://github.com/armbian/firmware";
    };
    kernel = {
      branch = "branch:linux-7.0.y";
      config = "linux-uefi-riscv64-legacy";
      config_path = "config/kernel/linux-uefi-riscv64-legacy.config";
      config_path_nix = "configs/linux-uefi-riscv64-legacy.config";
      exact_version = "7.0.14";
      hash = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4=";
      major_minor = "7.0";
      nvfetcher_key = "kernel-riscv64-branch-linux-7-0-y";
      patch_dir = "archive/uefi-riscv64-7.0";
      patches = [ ];
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    linux_family = "riscv64";
    uboot = {
      atf_branch = null;
      atf_hash = null;
      atf_platform = null;
      atf_source = null;
      atf_target_map = null;
      branch = "tag:v2025.10";
      config = "\${QEMU_UBOOT_BOOTCONFIG}";
      nvfetcher_key = "uboot-tag-v2025-10";
      patch_dir = "u-boot-qemu-riscv64";
      patches = [ ];
      source = "https://github.com/u-boot/u-boot";
      source_hash = "sha256-gaD4bZS58LIe+zYmdFxY5Q7nqovINfnebY9JQ5TkN+Q=";
      target_map = null;
    };
  };
}
