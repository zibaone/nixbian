{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "odroidn2l";
  dtb = null;
  family = "meson64";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    branch = "tag:v2023.10";
    config = "odroid-n2l_defconfig";
    nvfetcher_key = "uboot-tag-v2023-10";
    patch_dir = "v2023.10";
    patches = [
      "patches/uboot/v2023.10/board_jethubj100/0001-HACK-mmc-meson-gx-limit-to-24MHz.patch"
      "patches/uboot/v2023.10/board_jethubj100/0002-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
      "patches/uboot/v2023.10/board_jethubj100/0003-Copy-and-update-amlogic-2019-aml-partition-keyman-co.patch"
      "patches/uboot/v2023.10/board_jethubj100/0004-Copy-and-update-amlogic-2019-aml-partition-keyman-co.patch"
      "patches/uboot/v2023.10/board_jethubj100/0005-Add-usid-serial-mac-read-from-emmc.patch"
      "patches/uboot/v2023.10/board_jethubj100/0007-ARM-amlogic-revert-JetHub-D1-eth-mac-generation-with.patch"
      "patches/uboot/v2023.10/board_jethubj100/0008-board-amlogic-jethub-j100-fix-common-config-header.patch"
      "patches/uboot/v2023.10/board_jethubj80/0001-HACK-mmc-meson-gx-limit-to-24MHz.patch"
      "patches/uboot/v2023.10/board_jethubj80/0002-mmc-meson-gx-change-clock-phase-value-on-axg-SoCs.patch"
      "patches/uboot/v2023.10/board_jethubj80/0003-Copy-and-update-amlogic-2019-aml-partition-keyman-co.patch"
      "patches/uboot/v2023.10/board_jethubj80/0004-Copy-and-update-amlogic-2019-aml-partition-keyman-co.patch"
      "patches/uboot/v2023.10/board_jethubj80/0005-Add-usid-serial-mac-read-from-emmc.patch"
      "patches/uboot/v2023.10/board_jethubj80/0007-ARM-amlogic-revert-JetHub-D1-eth-mac-generation-with.patch"
      "patches/uboot/v2023.10/board_odroidn2l/meson64-boot-usb-nvme-scsi-first.patch"
    ];
    source_hash = "sha256-f0xDGxTatRtCxwuDnmsqFLtYLIyjA5xzyQcwfOy3zEM=";
  };
}
