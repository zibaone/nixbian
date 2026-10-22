# Nixbian package architecture

> Single source of truth: nvfetcher sources → family artifacts → board artifacts.
>
> Fundamental rule: every transformation is described in the generator, not in the metadata.

## Principles

### Single source of truth

The **nvfetcher sources** (`metadata/sources/generated.nix`) are the only entry point.
Every artifact derives from a source, directly or indirectly.

```
sources nvfetcher
  │
  ├── kernel-<family>-<branch>.src     ← fetchgit (raw source)
  ├── uboot-<board>-<branch>.src        ← fetchgit
  ├── kernel-<family>-<branch>.patches ← metadata (path lists)
  └── uboot-<board>-<branch>.patches    ← metadata
```

### Artifact tree

```
┌──────────────────────────────────────────────────────────────┐
│                      Sources nvfetcher                       │
│  (kernel-*, src-firmware-*, uboot-*, src-arm-trusted-*)      │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│             Family artifacts (per family-branch)             │
│                                                              │
│  kernel-<family>-<branch>    ← buildLinux (full kernel)      │
│  kernel-<family>-<branch>.src    ← fetchgit (source only)    │
│  kernel-<family>-<branch>.patches  ← metadata (list)         │
│  uboot-<family>-<branch>*   ← buildUBoot                     │
│  dtbs-<family>               ← family DTBs (dtbs_install)    │
│  firmwares-<family>          ← firmware build                │
└──────────────────────────┬───────────────────────────────────┘
                           │ extraction per board
                           ▼
┌──────────────────────────────────────────────────────────────┐
│              Board artifacts (per board-branch)              │
│                                                              │
│  uboot-<board>-<branch>         ← U-Boot build (complete)    │
│  uboot-<board>-<branch>.src     ← U-Boot source              │
│  uboot-<board>-<branch>.patches ← U-Boot patches             │
│  firmwares-<board>               ← firmware build            │
│  kernel-<board>-<branch>*       ← alias to family kernel     │
│  dtb-<board>-<branch>           ← extracted DTB (single)     │
└──────────────────────────────────────────────────────────────┘
```

### Rules

1. **A family builds its artifacts once.** All boards in the family
   share the same kernel, the same family DTBs, the same firmwares.

2. **A board artifact is extracted from the family artifact.** No rebuild.
   Example: `dtb-orangepizero3-current` depends on `dtbs-sunxi64` and extracts
   `sun50i-h618-orangepi-zero3.dtb`.

3. **The `dtb` field in the board metadata is the source of truth** for filtering.
   `dtb = "allwinner/sun50i-h618-orangepi-zero3.dtb"` → family directory = `allwinner/`.

4. **Every modification is made in the generator** (`generator.py`),
   never directly in `metadata/`.

## Kernel v2 contract (2026-10-18)

The kernel configuration mode is **explicit** and **actually applied** to the
build by `buildKernel` (`metadata/nix/library.nix`, copied verbatim from
`src/armbian_extractor/templates/library.nix`).

### Three configuration tiers

| Tier (`configMode`) | Config actually used | nixpkgs mechanism | Usage |
|---------------------|----------------------------|-------------------|-------|
| `armbian` (**default**) | **complete** Armbian `.config` of the family (e.g. `configs/linux-sunxi64-current.config`, referenced by `kernel.config_path_nix`) | `linuxManualConfig`: `ln -sv <config> build/.config` then `make oldconfig` — the Armbian mechanism | Production — config validated upstream by Armbian |
| `defconfig` | **upstream `make defconfig`** for the platform (`arch/<arch>/configs/defconfig`) + **family fragment** (`FAMILY_CONFIG_FRAGMENTS`, `CONFIG_*=y` lines) — ⚠️ this is **not** the Armbian config | `buildLinux`: fragment converted to *answers* (`SYSVIPC y`, `CONFIG_` prefix stripped) → `generate-config.pl` → `make config` | Fast build, standard boards |
| `nixpkgs` | common nixpkgs config (`common-config.nix`) | `buildLinux` (`enableCommonConfig = true`) | Development / tests |

- **Selection**: `hardware.nixbian.configMode = "armbian" | "defconfig" | "nixpkgs"` (default `armbian`).
- The `defconfig` tier is **not** an Armbian config: `arch/arm64/configs/defconfig` is the *upstream* defconfig (the family's Armbian patches do not modify it — verified on `sunxi-7.0`), completed by the family fragment. It is used for fast/dev builds; for a production kernel, the Armbian config is obtained with the `armbian` tier (`.config` copied verbatim from `config/kernel/linux-<fam>-<branch>.config`).
- `hardware.nixbian.extraConfig` (string) applies **in all modes**: under `defconfig`/`nixpkgs` it is concatenated to the *answers*, under `armbian` it is merged into the `.config` (`writeText` derivation + `allowImportFromDerivation`).
- `hardware.nixbian.configType` is **deprecated**: if `configMode` is not set, it serves as a fallback (`"minimal"` → `"defconfig"`).
- On the **HavenOS** side, the global choice is made in `services.havenos.kernel.mode`: `"nixpkgs"` (nixpkgs kernel, 0 builds) or `"nixbian"` (nixbian kernel, with `hardware.nixbian.configMode`).
- Why no `postPatch`: nixpkgs' `configurePhase` links `${configfile}` to `build/.config`, then runs `make oldconfig`. A `.config` written into the sources by a `postPatch` would be ignored. And `generate-config.pl` **cannot** read a raw `.config`: it expects *answers* (`SYSVIPC y`, no `CONFIG_` prefix, no `=`), otherwise it dies with "invalid config line", and a `y` answer on an option whose dependency is `m` triggers "repeated question" (Kconfig tristate propagation). Hence going through `configfile` for the `armbian` tier.
- `ARCH` is never hardcoded: nixpkgs already provides it in `makeFlags` (`arm64`, `arm`, `riscv`, `x86` depending on the platform).

### Exposed packages

| Package | Tier | Key |
|---------|------|-----|
| `kernel-<platform>` (e.g. `kernel-sunxi64-current`) | `armbian` (default) | family + branch |
| `kernel-<platform>-defconfig` | `defconfig` | family + branch |
| `kernel-<boardKey>` (e.g. `kernel-orangepizero3-current`) | `armbian` | board alias |
| `kernel-<boardKey>-defconfig` | `defconfig` | board alias |

The former names `kernel-<board>-armbian` (set `armbianKernels`) and the
`configType`/`extraConfigFlags` field are replaced: the `armbian` production tier
is now the default, and the option is called `configMode`.

### Actual DTB filtering

- Source of truth: the `dtb` field of each board (`"allwinner/sun50i-h618-orangepi-zero3.dtb"`).
- The generator collects the unique DTBs per `(family, branch)` (`platformDtbs`) and injects `dtb_list` **at the top level** of the meta passed to `buildKernel`.
- `buildKernel` applies an `overrideAttrs` to the final derivation:
  - removes the `dtbs` target from `buildFlags` (replaced by the **relative** targets `<vendor>/<file>.dtb`: the `%.dtb` rule in the kernel Makefile already prefixes `$(dtstree)/`, so a full path yields a doubled path and `No rule to make target`);
  - removes `dtbs_install` / `INSTALL_DTBS_PATH` from `installFlags`;
  - installs each DTB into `$out/dtbs/<relative path>` via `postInstall` (same layout as nixpkgs).
- `dtb_list == null` → original nixpkgs behaviour (all DTBs): backwards compatibility.

⚠️ **Why the previous mechanism was decorative**: `buildDTBs` is not an
argument of `buildLinux` — nixpkgs computes it from
`stdenv.hostPlatform.linux-kernel.DTB` (`pkgs/os-specific/linux/kernel/build.nix`).
Passing `buildDTBs = [...]` as an argument had no effect. Furthermore,
`make dtbs_install` does **not** depend on the `dtbs` target (kernel Makefile): the
build cannot be filtered without reinstalling the DTBs yourself.

> **Status**: real build succeeded (`armbian` tier, `kernel-orangepizero3-edge`, 2026-10-19) — 1 DTB filtered (`allwinner/sun50i-h618-orangepi-zero3.dtb`), 2637 modules, Armbian config converged (`modules.builtin`: `sun4i-drm`, `sun8i-*-ccu`…).

### Implementation in the generator

#### package.nix (per family)

The file `metadata/nix/families/<family>/package.nix` exposes:

```nix
{
  kernels = { ... };           # armbian tier (default, production)
  defconfigKernels = { ... };  # defconfig tier (+ family fragment)
  kernelSrcs = { ... };    # sources only (fetchgit)
  kernelPatches = { ... }; # patch lists
  uBoots = { ... };        # U-Boot builds
  ubootSrcs = { ... };     # U-Boot sources
  ubootPatches = { ... };  # U-Boot patches
  firmwares = { ... };     # firmware builds

  # family DTBs (all, built with make dtbs)
  familyDtbs = { ... };

  # individual DTBs per board (extracted from familyDtbs)
  boardDtbs = { ... };
}
```

#### boardDtbs — construction

```nix
boardDtbs = lib.mapAttrs (name: meta:
  let
    # Family kernel key (e.g. sunxi64-current)
    familyBranch = "${meta.family}-${meta.branch}";
    # Retrieves the prebuilt family DTBs
    familyDtbs = self.outputs.familyDtbs.${familyBranch};
    # Extracts the board's DTB
    dtbName = meta.dtb;  # "allwinner/sun50i-h618-orangepi-zero3.dtb"
    boardName = lib.last (lib.splitString "/" dtbName);
  in
  pkgs.runCommand "dtb-${name}" { } ''
    cp ${familyDtbs}/${boardName} $out
  ''
) boards;
```

### Tests

The tests in `tests/` validate the complete chain:

| Test | What it validates | Time |
|------|-----------------|-------|
| `dtb-test.nix` | `cpp + dtc direct` on family DTBs, board extraction | ~20 sec |
| `kernel-test.nix` (to do) | nvfetcher source → buildLinux → native HOSTCC | ~5 min |

**Rule for tests:** they must use the same sources (`generated.nix`)
and the same protocol as the generator. No hardcoded paths, no duplicated
hashes.

### Example: complete chain for the Orange Pi Zero 3

```
nvfetcher sources:
  kernel-sunxi64-branch-linux-6-18-y.src  ← fetchgit git.kernel.org

Family artifacts (sunxi64-current):
  kernel-sunxi64-current           ← buildLinux (armbian tier, default)
  kernel-sunxi64-current-defconfig ← buildLinux (defconfig tier + fragment)
  firmwares-sunxi64                ← firmware build

Board artifacts (orangepizero3-current):
  kernel-orangepizero3-current           ← alias to kernel-sunxi64-current
  kernel-orangepizero3-current-defconfig ← alias to kernel-sunxi64-current-defconfig
  uboot-orangepizero3-current            ← U-Boot build
```

### Status as of 2026-10-18

| Artifact | Status | Package |
|----------|--------|---------|
| `kernel-<family>-<branch>` (`armbian` tier, default) | ✅ Exists | `kernel-${name}` |
| `kernel-<family>-<branch>-defconfig` | ✅ Exists | `kernel-${name}-defconfig` |
| `kernel-<boardKey>` / `kernel-<boardKey>-defconfig` (board alias) | ✅ Exists | via `boardKernels` |
| `kernel-*-src` | ✅ Exists | `kernel-${name}-src` |
| `kernel-*.passthru.patches` | ✅ Exists | via passthru |
| `uboot-*` | ✅ Exists | `uboot-${name}` |
| `firmwares` | ✅ Exists | via legacyPackages |
| `familyDtbs` | ⏳ Not generated — DTB filtering goes through `dtb_list` (see "Kernel v2 contract") | — |
| `boardDtbs` | ⏳ Not generated — same as `dtb_list` | — |
| `kernel-<board>-dtb` | ⏳ Not generated | — |

> Kernels are validated by eval/parse; a first kernel was built on
> 2026-10-19 (`kernel-orangepizero3-edge`). The other boards remain
> uncompiled and untested.

## Publication decisions

### Portable paths

The `config_path`, `target_map` and `atf_target_map` fields are relative to the
root of the Armbian tree (`config/kernel/...`, `cache/sources/...`). No
`/nix/store/` path may appear in `metadata/`: it would depend on the
generation machine and make the catalogue non-reproducible. The generator
resolves relative paths when collecting kernel configs, and purges
the families/boards that are no longer present in the pinned Armbian version.

### Vendored patches (D1)

`metadata/nix/patches/` is a **generated and committed** artifact (~48 MiB, 3508
files). It is kept in the tree so that `metadata/` remains
self-sufficient: builds do not need to re-download the Armbian tree
and the patches actually applied are auditable in the repository.

Patches remain under their original licenses — GPL-2.0-only for the kernel,
GPL-2.0+ for U-Boot — and are not relicensed by the repository's GPL-3.0. The
`NOTICE` file documents this attribution.

### Kernel versions (cache)

`metadata/kernel-versions.json` is the committed cache of `exact_version`
values (`source|branch` → version). Default regeneration reuses it, which
makes it deterministic and usable offline. `--refresh-kernel-versions` (or
`REFRESH_KERNEL_VERSIONS=1 just refresh-metadata`) re-reads the upstream Makefiles
for an Armbian upgrade; a network failure keeps the already-known value.

### Generated inventories (D3)

`metadata/all-targets.json` is the composed catalogue produced by
Armbian's `targets-compositor.py` (1364 targets). It is not read by the Nix
build; it is used for auditing and by external tools.

`all_boards_all_branches.json` (dict indexed by board) and
`all_userspace_inventory.json` (list of distributions) have different
schemas and are generated by two distinct scripts (`board-inventory.py`,
`userspace-inventory.py`). They are not read by the build and are kept
as a snapshot of the Armbian inventory.
