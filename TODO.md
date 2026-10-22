# Nixbian Roadmap & Todo

This file lists the next development phases, architectural improvements, and backlog items for the Nixbian project. Completed tasks are archived in the git history.

---

## 🌍 Priority 1: Open-Source Release & Public Distribution
To prepare the repository for standard open-source publication and consumption.

* [x] **Add LICENSE**:
  * Add the GPL-3.0 license file to comply with Armbian's GPL-2.0+ lineage while providing robust copyleft protection.
* [x] **Expand Documentation for Consumers**:
  * Document how to import Nixbian as a flake input, register the NixOS module, and configure the basic options in `README.md`.
* [x] **Add Flake Starter Templates**:
  * Export a standard `templates` output in `flake.nix` (e.g. `nix flake init -t github:zibaone/nixbian#minimal`) to give new users a ready-to-run skeleton configuration.

---

## 🛡️ Priority 2: Code Quality & CI/CD Pipelines
To establish automated quality checks and professional standards for external contributions.

* [x] **Integrate Code Formatters**:
  * Set up `ruff` or `black` for Python formatting and `nixfmt` or `alejandra` for Nix formatting. Add a check step to the CI.
* [x] **Add CI Status Badge**:
  * Display a GitHub Actions build status badge at the top of `README.md`.

---

## ⚡ Priority 3: Eliminate Import-from-Derivation (IFD)
To ensure fast evaluation and full compatibility with strict CI environments (like Hydra) and official Nix flake registries.

* [x] **Remove dynamic versioned metadata IFD**:
  * Refactor `nix/parts/packages.nix` and `nix/lib.nix` to use pre-built static metadata directories instead of running the Python generator at evaluation time.
* [x] **Automate Metadata Upgrades**:
  * Set up a scheduled GitHub Actions workflow (cron) that runs `just upgrade` periodically, checks for changes, and commits/pushes them (or opens a PR) automatically.

---

## 📦 Priority 4: Firmware and Image Size Optimization
To decrease the footprint of target SD card images by pruning unnecessary firmware blobs.

* [x] **Implement DTB-driven Firmware Pruning**:
  * Write a Nix helper that parses the board's Device Tree binary (DTB) to extract compatible devices and prune the firmware package down to only the requested driver blobs.
* [x] **ZSTD-compressed Firmware Support**:
  * Update `buildFirmware` to compress files using `zstd` when the kernel configuration has `CONFIG_FW_LOADER_COMPRESS=y` enabled.

---

## 🔌 Priority 5: Native Device Tree Overlay (DTBO) Support
To allow users to configure and compile custom hardware overlays.

* [x] **Implement `hardware.nixbian.overlays`**:
  * Add the option to the NixOS hardware module.
  * Implement compilation of `.dts` files into `.dtbo` within Nix and configure extlinux/U-Boot to load them during the boot sequence.

---

## 🛡️ Priority 6: SBC Production Hardening & Storage Optimization
To protect hardware components (like SD cards) and enhance IoT edge deployments.

* [x] **Implement Flash Wear Mitigation**:
  * Introduce `hardware.nixbian.sdCard.wearMitigation` to mount `/tmp` in tmpfs, keep journal logs volatile in memory, and set up ZRAM swap.
* [x] **Add Edge Hardening Options**:
  * Add `hardware.nixbian.security.harden` option configuring sysctl parameters for network protection and kernel boundary security.
* [x] **Expand Filesystem Support**:
  * Relax the default file systems list to include flash-friendly filesystems like F2FS and Btrfs as defaults.

---

## 🚀 Priority 7: Distribution & Performance (Binary Cache & Flake Registries)
To ease adoption by pre-compiling kernels and officially distributing the project.

* [ ] **Public Binary Cache (Cachix / Hydra)**:
  * Set up an automated binary cache to host pre-compiled kernels, U-Boot bootloaders, and firmware binaries for all supported boards.
  * Still open. The first kernel build landed on 2026-10-19 (see Priority 10); a cache for all boards does not exist yet (`cachix push havenos` is currently manual).
* [ ] **Official Flake Registration**:
  * Register Nixbian in the official Nix Flake Registry and index to enable easy access via shorthand URI (e.g. `nixbian`).

---

## 🔌 Priority 8: Declarative Hardware Bus Management (GPIO, I2C, SPI)
To allow zero-configuration physical hardware hacking directly in Nix.

* [x] **High-level GPIO Configuration Options**:
  * Implement options like `hardware.nixbian.gpio.pins` for declaring direction, bias, and initial states.
* [x] **Declarative Bus Enablement (I2C, SPI)**:
  * Add abstractions like `hardware.nixbian.i2c.buses` and `hardware.nixbian.spi.buses` that automatically load appropriate overlays and device tree parameters.


---

## 🛠️ Priority 9: Kernel/U-Boot Developer Toolset (Fast Iteration Loop)
To enable low-level kernel and bootloader developers to hack, compile, and test configurations instantly.

* [x] **Interactive `menuconfig` Bridge**:
  * Build a script and devShell commands to boot into `menuconfig` and automatically export/translate the `.config` output into Nixbian's Nix-structured format (`.config.nix`).
* [x] **Incremental Compilation DevShells**:
  * Expose devshells (`nix develop .#kernel-dev-<board>`) pre-loaded with cross-compilation toolchains (GCC/Clang, headers) and unpacked sources to allow instant incremental compilation (`make`) outside the Nix build sandbox.
* [x] **QEMU Emulation & GDB Runner**:
  * Add `run-qemu` and `run-qemu --gdb` commands to the devShells to boot the compiled kernel in a cross-emulated QEMU environment with optional GDB step-by-step debugging.

---

## ⚙️ Priority 10: Kernel Configuration v2 (armbian / defconfig / nixpkgs)

The July 2026 "minimal kernel" feature was never functional: `merge_config.sh` has no `-e` option (fragments must be files), the `postPatch`-written `.config` was ignored by nixpkgs' `configurePhase`, `ARCH=arm64` was hard-coded (wrong for 14 of 37 families), the Armbian config was never passed to `buildLinux` (dead code), and DTB filtering was decorative (`buildDTBs` is not a `buildLinux` argument). No Nixbian kernel had been built at that point, so none of this ever failed loudly. v2 makes kernel configuration explicit and effective — see `docs/architecture-packages.md`.

* [x] **`configMode` in `buildKernel`** (`armbian` default / `defconfig` / `nixpkgs`): `armbian` passes the full Armbian `.config` as `configfile` to `linuxManualConfig` (`ln -sv` + `make oldconfig`); `defconfig`/`nixpkgs` use `buildLinux` with answers-style `extraConfig` (`CONFIG_` prefix stripped, both `.config` and answers syntaxes accepted, `autoModules = false` outside `nixpkgs`). Broken minimal-mode `postPatch` and dead `rawConfig`/`config` removed.
* [x] **Family fragments**: `FAMILY_CONFIG_FLAGS` → `FAMILY_CONFIG_FRAGMENTS` (`CONFIG_X=y` lines, one fragment per family; `rockchip-rv1106` intentionally empty).
* [x] **Real DTB filtering**: `dtb_list` applied through `overrideAttrs` (drop `dtbs`/`dtbs_install`, per-DTB build targets **relative** to the dts tree — the kernel `%.dtb` rule already prefixes `$(dtstree)/` — and `postInstall` into `$out/dtbs/`).
* [x] **Package & option rename**: `kernel-<name>` (armbian tier) + `kernel-<name>-defconfig`, board aliases included; `hardware.nixbian.configMode` + `extraConfig`; `configType` deprecated (`minimal` → `defconfig`).
* [x] **First real kernel build**: `kernel-orangepizero3-edge` (aarch64, armbian tier) built successfully on 2026-10-19 — `k9rac2p5…-linux-aarch64-unknown-linux-gnu-7.0.14` (Image, System.map, exactly 1 filtered DTB) + `hrcqs7iy…-…-modules` (2637 modules; Armbian config convergence visible in `modules.builtin`: `sun4i-drm`, `sun4i-usb-phy`, `sun8i-*-ccu`). The build surfaced and fixed two blockers: `extraConfig` needs answers (not `.config` syntax) and DTB make targets must be relative.
* [x] **Tier gates**: `just check-config orangepizero3-edge` (armbian: applied config identical to the family reference, 2714 symbols) and `just check-config orangepizero3-edge-defconfig` (defconfig: 5/5 family-fragment symbols applied in the generated `.config`).
* [ ] **Remove `.config.nix` from the repo** (decision of 2026-10-18, deferred): the structured Nix export is no longer read by `buildKernel` (v2 reads the raw `.config` via `config_path_nix`); plan the removal of `_convert_kconfig_to_nix` and the `config_struct_nix` field from the generator.

---

## 🎬 Priority 11: H616/H618 media & display (Orange Pi Zero 3 → NixELEC)

Full plan, evidence and work packages: **[docs/h618-media-plan.md](docs/h618-media-plan.md)**.

* [x] **WP0 — Collect Armbian patches**: `_collect_patches` was non-recursive → **0 patches** applied for the whole sunxi family (the kernel still built). Recursive collection + `series.conf` order + disabled patches + cache; `sunxi-7.0` = 475 patches, `sunxi-6.18` = 511, `sunxi-6.12` = 455. Proven at the derivation level: `structuredAttrs.patches` = 476.
* [x] **WP1 — DTB gate `just check-hw-caps <board>`**: decompiles the built DTB and requires `allwinner,sun50i-h616-video-engine` + `allwinner,sun50i-h616-dw-hdmi`, rejecting a `status = "disabled"` node (trap 0042/0043). Validated red on both kernels built before WP0.
* [x] **WP2 — Build + end-to-end proof for `edge`**: `9mih42kc…-linux-aarch64-unknown-linux-gnu-7.0.14` (35 MB Image, **a single DTB**), gate green (`sun50i-h616-video-engine` + `sun50i-h616-dw-hdmi`), `System.map` carries `cedrus_probe`/`cedrus_hw_probe` and `sun4i_drv_probe`/`sun8i_mixer_probe`; ~33 min under contention. **Remaining**: rebuild `current` (6.18) for the same proof.
* [ ] **WP3 — LibreELEC media delta (opt-in)**: VP9, 10-bit P010, AFBC, DI300 via a `kernel.extra_patch_dirs` metadata field (never the host's `extraPatches`). Port abandoned if 7.3-rc6 → 7.0.14 exceeds 2 sessions.
* [ ] **WP4 — Kodi userspace (HavenOS)**: **observed** — Kodi 21.3 (nixpkgs) cannot create an `AV_HWDEVICE_TYPE_V4L2REQUEST` hwdevice (`FindHWConfig()` requires `device_type == DRM`); backport PR xbmc#25467 (1 file), then patched `ffmpeg` (`v4l2-request`), override `ffmpeg_6` in `kodi-standalone.nix:216`, `cma=128M`.
* [ ] **WP5 — P4 evidence**: `dmesg` cedrus/HDMI probe, `v4l2-ctl --list-formats-out`, `ffmpeg -hwaccel v4l2request`, `kodi.log`, survives reboot.
* [ ] **WP6 — Upstream watch & removal**: when 7.4 is released (VE DT already in `sunxi/dt-for-7.4`), drop redundant patches; HDMI remains downstream until DE33/dw-hdmi is merged.
