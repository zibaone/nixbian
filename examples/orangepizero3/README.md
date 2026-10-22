# Orange Pi Zero 3 NixOS Example

This example demonstrates how to build a NixOS SD image for the Orange Pi Zero 3 using `nixbian` components (kernel and U-Boot).

## Prerequisites

- Nix with flakes enabled.
- An x86_64-linux host (for cross-compilation) or an aarch64-linux host.

## How to build

To build the SD image, run:

```bash
nix build .#nixosConfigurations.orangepizero3.config.system.build.sdImage
```

The resulting image will be available in `./result/sd-image/`.

## Writing to SD Card

```bash
# Replace /dev/sdX with your SD card device
sudo dd if=result/sd-image/nixbian-opizero3-aarch64-linux.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## Features

- **Kernel**: Custom Armbian-based kernel (sunxi64-edge).
- **U-Boot**: Custom U-Boot with Orange Pi Zero 3 specific patches.
- **Serial Console**: Enabled on `ttyS0` at 115200 baud.
- **Default User**: `root` with password `nix`.
