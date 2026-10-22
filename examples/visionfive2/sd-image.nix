{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
  ];

  # Define the nixbian options used in flake.nix
  options.nixbian = {
    uBoot = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "The U-Boot package to use for the image.";
    };
  };

  config = {
    nixbian.uBoot = lib.mkDefault config.hardware.nixbian.uBoot.package;
    # Bootloader configuration
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    # Kernel console for serial access (ttyS0 on JH7110 is at 115200 baud)
    boot.kernelParams = [
      "console=ttyS0,115200"
      "console=tty1"
      "earlycon=sbi"
    ];

    # SD Image configuration
    sdImage = {
      imageName = "${config.networking.hostName}-${pkgs.stdenv.hostPlatform.system}.img";

      populateRootCommands = "";
      populateFirmwareCommands = "";

      # VisionFive 2 boot ROM reads SPL at sector 40 and U-Boot Proper FIT at sector 1024
      postBuildCommands = ''
        SPL=${config.nixbian.uBoot}/u-boot-spl.bin.normal.out
        UBoot=${config.nixbian.uBoot}/u-boot.itb

        if [ -f "$SPL" ]; then
          echo "Writing VisionFive 2 SPL to image at sector 40..."
          dd if="$SPL" of=$img bs=512 seek=40 conv=notrunc
        else
          echo "Warning: SPL binary not found at $SPL"
        fi

        if [ -f "$UBoot" ]; then
          echo "Writing VisionFive 2 U-Boot FIT image to image at sector 1024..."
          dd if="$UBoot" of=$img bs=512 seek=1024 conv=notrunc
        else
          echo "Warning: U-Boot FIT binary not found at $UBoot"
        fi
      '';

      # Compress the image with zstd for easier sharing
      compressImage = true;
    };
  };
}
