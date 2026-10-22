# H616/H618 — VPU + display (Orange Pi Zero 3): implementation plan

> **Status**: WP0, WP1 and WP2 (edge) done and verified (2026-10-20).
> Remaining in WP2: rebuild `current` (6.18). WP3+ to do.
> **Scope**: make a Kodi appliance (NixELEC) functional on H616/H618 in
> Nix, without depending on a LibreELEC image.
> **This document is the source of truth for implementation sessions**: each
> WP is self-contained (context, files, commands, gate). Do not improvise a
> parallel path: if a WP does not apply, fix it here first.

---

## 1. State verified on 2026-10-20 (not a summary: reproducible facts)

### 1.1 The mainline kernel v7.0 has **neither** VPU **nor** HDMI for the H616

| Verification | Command | Result |
| --- | --- | --- |
| VE node in the dtsi | `curl -s .../torvalds/linux/v7.0/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi \| grep -c video-engine` | `0` |
| HDMI node in the dtsi | same `grep -c hdmi` | `0` |
| H616 compatible in the driver | `.../v7.0/drivers/staging/media/sunxi/cedrus/cedrus.c \| grep -c h616` | `0` |

**Consequence**: `CONFIG_VIDEO_SUNXI_CEDRUS=y` (present in the Armbian
sunxi64 config) is **dead weight** without a DT node. And a Kodi appliance
without HDMI cannot exist: **display is blocker #1, not the VPU**. The
initial external framing did not mention this point — that is its main gap.

### 1.2 Upstream state (Chen-Yu Tsai series)

- v1 2026-05-05, v2 2026-07-11, v3 2026-07-12 ("ready to be merged").
- Patches **5-7 (DT)**: applied in `sunxi/dt-for-7.4`
  (`d7287d940f3c`, `965a49fc413d`, `eabc3c090e81`) → VE node in **v7.4**.
- Patches **1-4 (bindings + `cedrus.c`)**: go through the media tree;
  **no evidence of a merge as of 2026-10-20**. The DT node without the driver
  compatible simply remains un-*probed* (no crash).
- The H616 compatible binds `sun50i_h6_cedrus_variant`: it therefore inherits
  `CEDRUS_CAPABILITY_H265_10_DEC` and VP8. **VP9 is not covered upstream.**
- HDMI: **still absent** from `sun50i-h616.dtsi` on master as of 2026-10-20.

### 1.3 What each downstream carries

**Armbian v26.5.1 — `patch/kernel/archive/sunxi-7.0` (480 files, 475 applied)**

| Need | Patch |
| --- | --- |
| VE node + `sram_c1` | `patches.armbian/arm64-dts-sun50i-h616-add-vpu-node.patch` |
| H616 driver compatible | `patches.armbian/drv-staging-media-sunxi-cedrus-add-H616-variant.patch` |
| SRAM C1 (driver) | `patches.armbian/drv-soc-sunxi-sram-add-h616-sram-c1.patch` |
| SRAM/`fw_devlink` dependencies | `patches.megous/fixes-7.0/0012`, `0013` |
| Cedrus (AFBC, clock, format) | `patches.media/media-cedrus-*` (4) |
| DE33/TCON-TV/HDMI PHY display pipeline | `patches.drm/0035,0037,0039,0040,0041,0042` |
| HDMI enabled on the board | `patches.drm/0043` (touches `sun50i-h618-orangepi-zero3.dts`) |

Limits: no VP9, no P010 (10-bit), no 10-bit AFBC, no DI300 deinterlacer.
The cedrus patch defines a `sun50i_h616_...` variant but **binds the H6
variant** (h616 struct unused) → H6 caps, including `H265_10_DEC`.
Note: Armbian's VE node **has no `iommu`** → everything goes through CMA
(family config: `CONFIG_CMA_SIZE_MBYTES=64`).

**LibreELEC master — `projects/Allwinner/patches/linux` (kernel 7.3-rc6)**

The only downstream that goes further: `0411` VP9, `0412-0414` P010 10-bit,
`0416/0419/0425` AFBC, `0421` `select V4L2_VP9`, `0422/0423` VC-1,
`0426` DI300 driver, `0435` deinterlacer node, `0700-0706` display+audio.
On the userspace side: `packages/multimedia/ffmpeg/patches/v4l2-request/0001` (+`0002-vc1`).
LibreELEC **does not patch Kodi** for Allwinner (only a Mali-Utgard subtitle
workaround).

### 1.4 Userspace in nixpkgs (verified on the machine)

```
$ ffmpeg -hide_banner -hwaccels
vdpau cuda vaapi drm opencl vulkan amf        # ← no v4l2request
$ ffmpeg -buildconf | grep v4l2
    --enable-v4l2-m2m                          # stateful only (cedrus = stateless)
```
- `pkgs.kodi-wayland` = **21.3**, `ffmpeg = ffmpeg_6`, overridable argument
  (`all-packages.nix:10263`) → clean injection point for a patched ffmpeg.
- Upstream Kodi (`DVDVideoCodecDRMPRIME.cpp`, master) only creates
  `AV_HWDEVICE_TYPE_DRM`. **The selection of a `V4L2REQUEST` hwdevice must be
  verified on 21.3 before promising anything** (WP4, step 1).

### 1.5 nixbian bug fixed (WP0) — the reason all of this was theoretical

`src/armbian_extractor/generator.py::_collect_patches` used
`patch_src.glob("*.patch")`: **non-recursive**. The sunxi sets store their 480
patches in subdirectories (`patches.armbian/`, `patches.drm/`, `patches.media/`,
`patches.megous/`) → **0 patches collected**, with no error (the output directory
is created, the kernel builds anyway). Measurement before the fix:

```
sunxi-6.12: 0    sunxi-6.18: 0    sunxi-7.0: 0    filogic-6.12: 0   qcs6490-6.18: 0
rockchip64-7.0: 163 (flat files → OK)
```
So `kernel-orangepizero3-edge` from 2026-10-19 = **vanilla stable + Armbian
`.config`**, without HDMI or VE.

Fix: recursive traversal, **`series.conf` order** (the `-patch` lines are
disabled upstream), relative tree preserved (identical names between
subdirectories), cache by `(component, patch_dir)` (737 boards share the
same sets), unconditional copy (a modified patch with a constant name must be
refreshed). Tests: `tests/test_generator.py::test_collect_patches_*` (3 tests).

After regeneration (v26.5.1):

```
kernel/archive/sunxi-6.18 : 511 patch(s) — series.conf order (6 disabled), 5 unlisted
kernel/archive/sunxi-7.0  : 475 patch(s) — series.conf order (1 disabled), 4 unlisted
kernel/archive/sunxi-6.12 : 455 patch(s) — series.conf order (1 disabled)
```
Proof that the patches **really** reach the build (not just the eval):

```
$ D=$(nix eval --raw '.#kernel-orangepizero3-edge.drvPath')
$ nix derivation show "$D" | jq '.derivations[].structuredAttrs.patches | length'
476            # 475 Armbian + randstruct nixpkgs
```
**Definitive gate**: `dtc -I dtb -O dts result-opi-edge/dtbs/allwinner/sun50i-h618-orangepi-zero3.dtb`
must contain `video-codec@1c0e000` and an `hdmi@…` node.

---

## 2. Layer split (decision)

| Layer | Responsibility | Must NOT contain |
| --- | --- | --- |
| **nixbian** | kernel patches, config, DTB, U-Boot, firmware, devshells, NixOS module | Kodi, ffmpeg, appliance profiles, images |
| **HavenOS** | profiles (kodi-standalone), patched ffmpeg, Mesa/Panfrost, cage, images, P4 evidence | ad hoc kernel patches (`extraPatches` = diagnostic fallback only) |
| **New repository** | ❌ nothing for now | — |

**No separate project for the board**:
1. the delta is **family** (sunxi64: 40 boards per branch, including 11 explicit
   H616/H618) + **profile** (kodi),
   not board;
2. both seams already exist (`hardware.nixbian.extraPatches`,
   `excludePatchPatterns`, `configMode`; on the HavenOS side the `ffmpeg_6`
   overlay in `kodi-standalone.nix` and the `board × profile` matrix in
   `parts/hosts.nix`);
3. a 3rd repository = 3 pins to converge and a duplicated kernel build (~26 min).

We reopen the question **only** if the goal becomes publishing a community
artifact (distribution) or upstreaming the userspace stack: that would be
"NixELEC the product", backed by HavenOS, not one repository per board.

---

## 3. Work packages

Each WP is independent and deliverable on its own. Recommended order: WP1 → WP2 → WP4 →
WP3 → WP5. WP3 is the only one at risk of patch conflicts: do not start it before
WP2 is green.

### WP0 — Collection of Armbian patches (DONE)

- **Files**: `src/armbian_extractor/generator.py` (`_read_series`,
  `_collect_patch_dir`, `_collect_patches`), `tests/test_generator.py`.
- **Gate**: `pytest` (44 ✓), `check-drift` green, `structuredAttrs.patches` = 476.
- **Expected side effect**: `metadata/` gains ~1749 patch files
  (~30 MB). That is the price of Armbian parity; do not gitignore them.

### WP1 — "Hardware capabilities in the DTB" gate (DONE)

Objective: turn manual DTB verification into a CI gate, so that the
"0 patches applied" regression can no longer pass silently.

- **File**: `scripts/check_hw_caps.py` (new) + `check-hw-caps <board>` recipe
  in `Justfile`.
- **Not in `just check`**: the gate requires a built kernel (~26 min);
  `just check` must remain evaluable in seconds. It is run by hand or in CI
  after the build (like `check-config` and `check-modules`).
- **Input**: the built kernel (`result-opi-edge` or `nix build .#kernel-<board>`).
- **Expected**: per-board table of required compatibles, e.g.
  `orangepizero3-edge` → `allwinner,sun50i-h616-video-engine` (node
  `video-codec@1c0e000`) and `allwinner,sun50i-h616-dw-hdmi` (node `hdmi@6000000`,
  compatibles verified in `patches.drm/0042`).
- **Implementation**: `dtc -I dtb -O dts`, then locate the node carrying the
  compatible and read its own `status` (sub-node `status` values are
  excluded). Three verdicts: `absent`, `disabled` (missing board patch, e.g.
  `0043`), `okay`. Unit tests on a synthetic DTS:
  `tests/test_check_hw_caps.py`.
- **Gate**: `just check-hw-caps orangepizero3-edge` green **and** red on a
  kernel built before WP0 (validated on `k9rac2p5…` and `9hh732bf…`).
- **Forbidden**: do not read `metadata/board_metadata.json` (written before
  collection, it never contains `patches`).

### WP2 — End-to-end proof of the patched kernel (edge DONE; current pending)

- **Commands**:
  ```
  nix build .#kernel-orangepizero3-edge -o result-opi-edge   # ~26 min, 16 cores
  just check-hw-caps orangepizero3-edge
  just check-config orangepizero3-edge
  ```
- **Gate**: DTB with `video-codec@1c0e000` + HDMI node; `.configfile` unchanged
  vs family reference; no patch conflict in the build log.
- **If a patch does not apply**: identify the offending file in
  `/tmp/kbuild.err`, then exclude it **by pattern** on the board side
  (`hardware.nixbian.excludePatchPatterns`) or on the metadata side (`overrides.json`),
  never by editing `metadata/`.
- **Deliverable**: record the store hash + the `dtc` output in §6.

### WP3 — LibreELEC media delta (VP9 / P010 / AFBC / DI300) — nixbian, opt-in

Objective: VP9 and HEVC 10-bit, which neither mainline nor Armbian provides.
**Prerequisite**: WP2 green (otherwise we stack patches on a broken base).

- **Source**: `projects/Allwinner/patches/linux/0406-0435` (LibreELEC master,
  kernel 7.3-rc6) — about 30 patches. Vendor them in the repository:
  `metadata/nix/patches/kernel/sunxi-7.0-media/` with a `series.conf`.
- **Mechanics**: new metadata field `kernel.extra_patch_dirs = [ "kernel/sunxi-7.0-media" ]`
  emitted by the generator for the `sunxi64-edge` platform only, consumed by
  `_collect_patches` (same path as `patch_dir`, `series.conf` order).
  **Do not** go through `hardware.nixbian.extraPatches` (that would be host
  config for a platform capability).
- **Known conflicts**: `0424` (LibreELEC VE node) duplicates the Armbian patch
  `arm64-dts-sun50i-h616-add-vpu-node.patch` → **choose a single one** (keep
  Armbian, skip 0424). `0417/0418` extend format filtering; they
  assume `0412` applied.
- **Gate**: `structuredAttrs.patches` increases by the expected count AND build green
  AND `v4l2-ctl --list-formats-out` lists `VP9` + `H265` in addition to H264.
- **Possible abandonment**: if the 7.3-rc6 patches do not apply cleanly on
  7.0.14 and the porting cost exceeds 2 sessions, we stay on H.264/HEVC 8-bit
  and document the rejection (explicit decision, not silence).

### WP4 — Kodi userspace chain (HavenOS)

**Step 1 — VERIFIED on 2026-10-20: Kodi 21.3 is NOT compatible.**

Full mechanism (real source, tag `21.3-Omega` = what nixpkgs 21.3 builds):

| Piece | Fact |
| --- | --- |
| patched ffmpeg (LibreELEC `v4l2-request/0001`) | adds a **device type** `AV_HWDEVICE_TYPE_V4L2REQUEST` (`libavutil/hwcontext_v4l2request.c`); stateless decoders expose an hw config `HWACCEL_V4L2REQUEST` = `HW_CONFIG_HWACCEL(1,0,0, DRM_PRIME, V4L2REQUEST, …)` → pix_fmt `DRM_PRIME`, method `HW_DEVICE_CTX`, device `V4L2REQUEST` |
| Kodi 21.3 `FindHWConfig()` | requires `config->device_type == AV_HWDEVICE_TYPE_DRM` → **never selects** the v4l2request config, falls back to `avcodec_find_decoder` (soft) |
| Kodi master (22) | same function **relaxed**: accepts any `HW_DEVICE_CTX`/`INTERNAL` → creates the `V4L2REQUEST` device and it works (PR xbmc#25467 "v4l2request-hwdevice", **1 file +29/−25**, merged 2024-12-21) |
| LibreELEC | does not patch Kodi for this: it builds Kodi **master** (`PKG_VERSION=01d4146d…`, a commit, not a tag) — hence it works on their side |

Consequences for HavenOS:
```
nix eval --raw nixpkgs#kodi-wayland.version      # 21.3 (only one available in nixpkgs)
```
- **Backport** of #25467 onto 21.3: 1 file (`DVDVideoCodecDRMPRIME.cpp`),
  patch to vendor in HavenOS (`pkgs/kodi/patches/`), low risk — **recommended
  path**.
- Or bump Kodi 22: package to write (nixpkgs provides none) — costly.
- Do NOT promise hwdec before this patch: `IsSupportedHwFormat` does accept
  `DRM_PRIME` in 21.3, but the `device_type == DRM` test blocks everything.

**Step 2**: `pkgs/ffmpeg-v4l2request/default.nix` (HavenOS)
- nixpkgs `ffmpeg/generic.nix` only exposes `withV4l2` (libv4l2) and `withV4l2M2m`
  (`--enable-v4l2-m2m`, **stateful**): the `--enable-v4l2-request` option comes from the
  LibreELEC patch, it does not exist upstream.
- Base `ffmpeg_6` (the one Kodi 21.3 links) + `v4l2-request/0001` (+`0002-vc1`);
  `configureFlags` += `--enable-v4l2-request --enable-libudev`; `buildInputs`
  += `udev`.
- Integration: `modules/profiles/kodi-standalone.nix:216` already overrides
  `ffmpeg_6` (pruning of x264/x265/vpx/aom) — it is **this** point that must be
  replaced by the patched package; Kodi then inherits the decoder without any
  additional override.
- **Gate**: `ffmpeg -hwaccels | grep v4l2request`.

**Step 3**: NixOS kernel + image (still HavenOS)
- `boot.kernelParams = [ "cma=128M" ]` in
  `modules/hardware/families/sunxi64/overrides.nix` (current stub: a commented-out
  example for this board) — Armbian VE node without IOMMU; 64 MB by default,
  insufficient for 1080p multi-ref HEVC. Test 256M if 4K/10-bit.
- The configuration already exists: `nixosConfigurations` is generated as a
  board × profile matrix (`parts/hosts.nix`) → `orangepizero3-edge-kodi`.
- **Gate**: `nix eval .#nixosConfigurations.orangepizero3-edge-kodi.config.system.build.toplevel.drvPath`
  then build of the SD image.

### WP5 — P4 evidence (HavenOS, real hardware)

Minimal protocol, to run on the board, outputs to paste into §6:
1. `dmesg | grep -iE "cedrus|sun8i-dw-hdmi|sun4i-drm"` → probe without error.
2. `v4l2-ctl --list-devices` → one `cedrus` device.
3. `v4l2-ctl -d /dev/video0 --list-formats-out` → `H264`, `HEVC` (+`VP9` if WP3).
4. `ffmpeg -hwaccel v4l2request -hwaccel_output_format drm_prime -i sample1080p.h264 -f null -`
   → no CPU fallback (measure `top`: < 30 % of one core).
5. `kodi.log`: `creating v4l2request hwdevice context`, no
   `Failed setup for format drm_prime`.
6. Reboot: the 5 previous points hold after reboot (image, not session
   state).

### WP6 — Upstream watch and patch removal

Removal criteria, to re-check at each release (7.4, then media merge):
- VE node in upstream `sun50i-h616.dtsi` **and** compatible in `cedrus.c`
  → remove `arm64-dts-sun50i-h616-add-vpu-node.patch` + `drv-staging-media-sunxi-cedrus-add-H616-variant.patch`.
- HDMI/DE33 upstream → remove `patches.drm/0035-0043`.
- Any removal is done **on the Armbian side** first (bump of the `versions.json`
  pin when Armbian follows), otherwise via documented `excludePatchPatterns`.

---

## 4. Rules for subagents (non-negotiable)

1. **Never edit `metadata/` by hand.** Change the template
   (`src/armbian_extractor/templates/*.nix`) or the generator, then regenerate:
   ```
   NIXBIAN_SKIP_PREFETCH=1 nix run . -- \
     --armbian-src result-source \
     --outdir metadata --armbian-version v26.5.1
   ```
   (`nix build '.#"armbian-source-v26.5.1"' -o result-source` if the store path
   has disappeared.)
2. **`nix run .` only sees tracked/`git add`ed files.** After editing
   `src/`, `git add` before running the extractor, otherwise the old code runs.
3. **One kernel build at a time** (~26 min, 16 cores). Check `nproc`/load
   before; do not run two boards in parallel.
4. **Prove at the derivation level**, not at eval: `structuredAttrs.patches`,
   `buildFlags`, then the DTB. An attribute that evaluates is not an attribute that
   acts.
5. **Do not touch `HavenOS/flake.lock`** (another session modified it);
   use `--override-input nixbian path:$HOME/Bureau/nixbian` for
   trials.
6. **Separate commits**: `fix(generator)` / `feat(gate)` / `docs(plan)` — no
   mixing code+doc in the same commit.
7. Any claim in this document must be **re-verified** before being
   propagated (command + output), not copied.

---

## 5. Open decisions

| # | Question | Recommendation | Who decides |
| --- | --- | --- | --- |
| D1 | Target branch: `edge` 7.0.14 or `current` 6.18.57 | `edge` first (the Armbian `sunxi-7.0` patches are written for that series); `current` afterwards if the image must follow the LTS | user |
| D2 | Can Kodi 21.3 use `v4l2request`? | **Decided (WP4 step 1)**: no — `FindHWConfig()` requires `device_type == DRM`. Backport PR xbmc#25467 (1 file, +29/−25) onto 21.3; do not package Kodi 22 for this | done |
| D3 | VP9/P010 via LibreELEC | attempt WP3 after WP2; documented abandonment if porting > 2 sessions | user |
| D4 | AFBC (requires the DRM-side decompressor, LibreELEC `0244-0250`) | do not enable until rendering is validated in plain NV12 | WP5 |
| D5 | Vendored patches (`metadata/nix/patches`, 48 MB / 3508 files) vs paths to `inputs.armbian-source` | keep vendoring: patches are individual content-addressed store objects, whereas a path into the Armbian source would pull the whole tree (~hundreds of MB) into every kernel's closure | user |

---

## 6. Evidence log

| Date | Step | Command | Result |
| --- | --- | --- | --- |
| 2026-10-20 | WP0 | `pytest` | 37 passed |
| 2026-10-20 | WP0 | `nix derivation show` on `.#kernel-orangepizero3-edge.drvPath` | `structuredAttrs.patches` = 476 (475 Armbian + randstruct) |
| 2026-10-20 | WP0 | v26.5.1 regeneration | sunxi-7.0: 475, sunxi-6.18: 511, sunxi-6.12: 455 |
| 2026-10-20 | WP1 | `check_hw_caps.py --kernel` on the 2 kernels built before the fix (`9hh732bf…`, `k9rac2p5…`) | ❌ `video-engine` absent, ❌ `dw-hdmi` absent — the gate does detect the regression |
| 2026-10-20 | WP2 | `nix build .#kernel-orangepizero3-edge` | `9mih42kc…-linux-aarch64-unknown-linux-gnu-7.0.14`: Image 35 MB, 1 DTB; ~33 min (contention: a `rustc` from another session was running) |
| 2026-10-20 | WP2 | `dtc -I dtb -O dts` on `sun50i-h618-orangepi-zero3.dtb` | `video-codec@1c0e000` (`allwinner,sun50i-h616-video-engine`, `allwinner,sram = <&sram_c1>`, clocks `ahb/mod/ram`); `hdmi@6000000` (`sun50i-h616-dw-hdmi`, fallback `sun50i-h6-dw-hdmi`), two active nodes |
| 2026-10-20 | WP2 | `just check-hw-caps orangepizero3-edge` | ✅ (the same gate on `k9rac2p5…` and `9hh732bf…`: ❌) |
| 2026-10-20 | WP2 | `grep -c cedrus System.map` on the built kernel | 107 symbols, including `cedrus_probe`, `cedrus_hw_probe` (so `=y`, not a module) |
| 2026-10-20 | WP4/step 1 | `FindHWConfig()` in Kodi `21.3-Omega` + master, LibreELEC ffmpeg patch, `PR xbmc#25467` | 21.3 ❌ (requires `device_type == DRM`); master ✅ (relaxed, 1 file +29/−25); LibreELEC builds Kodi master |
