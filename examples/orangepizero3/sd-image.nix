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

    # Kernel console for serial access
    boot.kernelParams = [
      "console=ttyS0,115200"
      "console=tty1"
    ];

    # SD Image configuration
    sdImage = {
      imageName = "${config.networking.hostName}-${pkgs.stdenv.hostPlatform.system}.img";

      populateRootCommands = "";
      populateFirmwareCommands = "";

      # Allwinner/Sunxi bootloader starts at 8KB
      # We use postBuildCommands to write it to the image
      postBuildCommands = ''
        # The u-boot-sunxi-with-spl.bin is the standard for Allwinner 64-bit
        UBoot=${config.nixbian.uBoot}/u-boot-sunxi-with-spl.bin
        if [ -f "$UBoot" ]; then
          echo "Writing U-Boot to image..."
          dd if="$UBoot" of=$img bs=1024 seek=8 conv=notrunc
        else
          echo "Warning: U-Boot binary not found at $UBoot"
          # Fallback to other possible names if necessary
          for f in ${config.nixbian.uBoot}/*.bin; do
            echo "Available bin: $f"
          done
        fi
      '';

      # Compress the image with zstd for easier sharing
      compressImage = true;
    };
  };
}
