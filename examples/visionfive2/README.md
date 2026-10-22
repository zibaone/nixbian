# StarFive VisionFive 2 NixOS Example

This example demonstrates how to build a NixOS SD image for the StarFive VisionFive 2 (RISC-V 64-bit) using `nixbian` components (kernel and U-Boot).

## Prerequisites

- Nix with flakes enabled.
- An x86_64-linux host (for cross-compilation) or a native riscv64-linux host.

## How to build

To build the SD image (cross-compiled from x86_64-linux to riscv64-linux), run:

```bash
nix build .#nixosConfigurations.visionfive2.config.system.build.sdImage
```

The resulting image will be available in `./result/sd-image/`.

## Writing to SD Card

```bash
# Replace /dev/sdX with your SD card device
sudo dd if=result/sd-image/nixbian-visionfive2-riscv64-linux.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## Features

- **Architecture**: RISC-V 64-bit (`riscv64-linux`).
- **Kernel**: Vendor kernel (starfive2-vendor).
- **U-Boot**: JH7110 specific U-Boot with SPL and U-Boot Proper (FIT image) written to raw sector offsets (40 and 1024 respectively).
- **Serial Console**: Enabled on `ttyS0` at 115200 baud with early console support (`earlycon=sbi`).
- **Default User**: `root` with password `nix`.
