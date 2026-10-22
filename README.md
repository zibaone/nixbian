# Nixbian 🚀

[![Nix CI](https://github.com/zibaone/nixbian/actions/workflows/nix.yml/badge.svg)](https://github.com/zibaone/nixbian/actions/workflows/nix.yml)
[![License: GPL-3.0-only](https://img.shields.io/badge/license-GPL--3.0--only-blue.svg)](LICENSE)

Nixbian is a **metadata, patch and kernel-configuration engine** built on top of
the **Armbian** build framework, for the **Nix** ecosystem.

It turns a pinned Armbian revision (`versions.json`) into a static Nix catalog:
`metadata/boards.json`, `metadata/nix/families/*/boards/*.nix`,
`platforms.nix`, `library.nix`, kernel configurations and vendored patches.

> **Status: experimental (0.3.0).** The catalog covers **737 board-branch
> entries**, but only **one kernel has been built** so far (Orange Pi Zero 3,
> `edge` branch, 2026-10-19). The other targets are **evaluated**, not validated
> on hardware. No NixOS image has been validated yet.

## What it is / what it is not

**It is:**

- a deterministic extractor for Armbian metadata (boards, families, branches,
  sources, patches, kernel configs);
- a Nix library (`metadata/nix/library.nix`) to build kernels, U-Boot, ATF and
  firmware from that metadata;
- a NixOS module (`nixosModules.nixbian`) that wires those packages for a board;
- a public catalog (`metadata/board_metadata.json`) consumable by external tools.

**It is not:**

- a Linux distribution or a kernel fork;
- a provider of ready-to-flash images;
- a binary cache or a repository of prebuilt packages;
- a replacement for Armbian: sources, configs and patches come from Armbian.

## Quick start

```bash
git clone https://github.com/zibaone/nixbian
cd nixbian
nix develop
just check
```

`just check` verifies formatting, template drift, evaluates a few boards and runs
the tests. It does not compile any kernel.

### Start from the template

```bash
nix flake init -t github:zibaone/nixbian
```

### Use Nixbian as a flake input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixbian.url = "github:zibaone/nixbian";
    nixbian.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixbian, ... }: {
    nixosConfigurations.my-sbc = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # or riscv64-linux, armv7l-linux…
      modules = [
        nixbian.nixosModules.nixbian
        ./configuration.nix
      ];
    };
  };
}
```

### Configure the hardware module

```nix
{ config, pkgs, ... }:
{
  hardware.nixbian = {
    enable = true;
    board = "orangepizero3";  # Armbian board identifier
    kernelVendor = "edge";    # current, edge or vendor
  };
}
```

| Option | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `hardware.nixbian.enable` | boolean | Enables kernel, firmware and bootloader wiring. | `false` |
| `hardware.nixbian.board` | string | Board identifier (e.g. `orangepizero3`, `orangepi5`, `visionfive2`). | — |
| `hardware.nixbian.kernelVendor` | string | Armbian kernel series (`current`, `edge`, `vendor`). | `"current"` |
| `hardware.nixbian.configMode` | enum | `armbian` (full Armbian config), `defconfig` (upstream defconfig + family fragment) or `nixpkgs`. | `"armbian"` |
| `hardware.nixbian.extraConfig` | string | Additional Kconfig fragment (`CONFIG_X=y`). | `""` |
| `hardware.nixbian.extraPatches` | list of paths | Additional `.patch` files for the kernel. | `[]` |
| `hardware.nixbian.excludePatchPatterns` | list of regex | Armbian patches to exclude. | module defaults |
| `hardware.nixbian.pruneFirmware` | boolean | Prunes firmware according to the board DTB. | `true` |
| `hardware.nixbian.compressFirmware` | boolean | ZSTD compression of firmware when the kernel supports it. | `true` |
| `hardware.nixbian.overlays` | list | Device Tree overlays compiled and applied at boot. | `[]` |
| `hardware.nixbian.sdCard.wearMitigation.enable` | boolean | tmpfs `/tmp`, volatile journald, ZRAM swap. | `true` |
| `hardware.nixbian.security.harden` | boolean | Hardening sysctl settings. | `false` |

The `hardware.nixbian.uBoot.*`, `i2c`, `spi`, `gpio` and `kernelModules.*`
options are documented in `nix/parts/nixos-module.nix`.

> `hardware.nixbian.configType` (old name) is **deprecated** in favor of
> `configMode`. The `-armbian` package suffix no longer exists: the `armbian`
> tier is the default.

### Build a board

```bash
nix build .#orangepizero3-edge          # board firmware
nix build .#uboot-orangepizero3-edge    # U-Boot
nix build .#kernel-orangepizero3-edge   # kernel (slow: full build)
```

## Metadata pipeline

The project uses **Just** to orchestrate the pipeline:

```bash
nix develop
just upgrade                # versions + metadata + hashes (slow)
just refresh-metadata       # metadata only (kernel cache reused)
just fetch-board orangepizero3  # hashes for a single board
just fetch-hashes           # hashes for all sources (66 sources)
just check                  # format + drift + evals + tests
```

`just refresh-metadata` is **deterministic**: it reuses
`metadata/kernel-versions.json`. To re-read upstream Makefiles during an Armbian
upgrade:

```bash
REFRESH_KERNEL_VERSIONS=1 just refresh-metadata
```

### Explore the catalog

```bash
nix run .#list-families
nix run .#list-boards sunxi64
nix eval .#legacyPackages.x86_64-linux.boards --apply builtins.attrNames
```

### Development shells

Per-board devShells allow incremental kernel or U-Boot builds outside the Nix
sandbox:

```bash
nix develop .#kernel-dev-orangepizero3-current
nix develop .#uboot-dev-orangepizero3-current
```

Useful commands in the kernel shell: `unpack-kernel`, `init-config`,
`menuconfig`, `save-config` (copies the `.config` **verbatim** into the
repository), `run-qemu`, `run-qemu --gdb`.

## Metadata layout

`metadata/nix` is a **generated and committed** artifact. Never edit it by hand:
fix the generator and regenerate.

- `metadata/boards.json`: index of the 737 board-branch entries (read by the module);
- `metadata/board_metadata.json`: full catalog, consumable by external tools;
- `metadata/nix/families/<family>/`: `platforms.nix`, `boards/*.nix`, kernel configs;
- `metadata/nix/library.nix`: `getPatches`, `applyPatches`, `buildKernel`, `buildUBoot`, `buildATF`;
- `metadata/nix/patches/`: vendored Armbian patches (3508 files, ~48 MiB);
- `metadata/nvfetcher.sources.toml` / `nvfetcher.lock.toml`: source definitions;
- `metadata/sources/generated.nix`: nvfetcher hashes;
- `metadata/kernel-versions.json`: exact kernel version cache;
- `metadata/all-targets.json`, `all_boards_all_branches.json`, `all_userspace_inventory.json`: Armbian inventories (not read at build time).

## Versions

- **Project version**: `pyproject.toml` (0.3.0), tag `v0.3.0`.
- **`versions.json`**: table of pinned Armbian tags (`rev` + `hash`), **not** the
  project version.
- **`metadata/kernel-versions.json`**: exact kernel versions, reused by default;
  `--refresh-kernel-versions` refreshes them.

## Tests and gates

```bash
just check-format            # ruff + nixfmt --check (does not modify files)
just check-drift             # templates -> metadata
nix develop --command pytest # 56 tests
nix flake check              # metadata checks + 6 NixOS evaluations + CLI
just check-config orangepizero3-edge
```

CI workflow details are in [`docs/ci.md`](docs/ci.md); the package architecture
is described in [`docs/architecture-packages.md`](docs/architecture-packages.md).

## Sources and credits

- **Armbian** ([`armbian/build`](https://github.com/armbian/build)): metadata,
  kernel configurations and vendored patches. Patches are redistributed under
  their original licenses.
- **Linux**, **U-Boot**, **ARM Trusted Firmware**: upstream sources built by the
  packages (kernel GPL-2.0-only, U-Boot GPL-2.0+, ATF BSD-3-Clause).
- **LibreELEC**: some media patches come from its tree.
- Armbian versions are pinned in `versions.json`.

See [`NOTICE`](NOTICE) for the complete attribution.

## License

Nixbian's code is distributed under **GPL-3.0-only** (see [`LICENSE`](LICENSE)).
Vendored components keep their original licenses; the repository's GPL-3.0 does
not relicense them.

## Contributing and security

- [`CONTRIBUTING.md`](CONTRIBUTING.md): workflow, metadata generation, commit
  conventions and gates.
- [`SECURITY.md`](SECURITY.md): private vulnerability reporting.
- [`CHANGELOG.md`](CHANGELOG.md): release history.

---

*The **Nixbian** project — built with ❤️ on top of Armbian.*
