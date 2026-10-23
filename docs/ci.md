# CI and automation

## Workflows

| File | Trigger | Role |
| --- | --- | --- |
| `.github/workflows/nix.yml` | PR, push to `main`/`master` | `nix flake check` (metadata checks + 6 board evaluations + CLI), `just check-format`, `just check-drift`, `pytest`, the kernel config gate over every family/branch pair, `just check` |
| `.github/workflows/metadata-config.yml` | cron `0 7 * * 1` (Monday), manual | Single owner of the generated state: `update-versions` (new Armbian tags), `refresh-metadata` (regeneration, with kernel version refresh), `scripts/resolve_lock.py` (hashes), `scripts/check_all_configs.py` (gate) — then branch `auto/metadata-config`, **no pull request** |

Scheduled jobs **never** push to `master` and **never open a pull request**:
they push the `auto/*` branch and stop there. Reviewing that branch, running
CI on it and merging it are human decisions, taken when someone asks for it.

There is one scheduled workflow on purpose. `versions.json`, `metadata/` and
the nvfetcher hashes are produced by the same generator run, so splitting them
across several crons means several branches competing over the same files.

It runs **weekly**. Every branch that moved upstream needs its own
`nix-prefetch-git` snapshot, and a kernel repository takes minutes: the first
measurement found 35 changed sources in a single day, which is close to an
hour of wall clock when serialised. `scripts/prefetch.py` now runs them eight
at a time (`NIXBIAN_PREFETCH_JOBS` to tune), and the weekly cadence keeps the
volume low. The configuration gate is not on that schedule — `nix.yml` runs it
on every pull request and every push, which is where a metadata regression can
actually appear.

## The kernel config gate

`scripts/check_all_configs.py` answers one question for the whole catalogue:
*is the family's Armbian `.config` really the one the kernel package applies?*

The wiring is not per board. A `family-branch` pair maps to a single kernel
package, so one evaluation decides for all the boards of that pair: 737 boards
collapse to 57 pairs and 53 reference configs. Two consequences:

- **cost**: a single `nix eval` extracts `configMode` and `configfile` for all
  1616 `kernel-*` attributes in about 3 s, instead of one `nix build` and two
  `nix eval` per board;
- **granularity**: a divergence is reported once per pair, with the number of
  affected boards.

The gate compares the applied config with the reference byte-for-byte, and
distinguishes three tiers: `armbian` (checked), `defconfig` (family fragment,
not checked here) and `nixpkgs` (no Armbian config by design). A pair with no
kernel package at all is reported as a warning, not a failure: upstream
Armbian sometimes ships a branch without a config file (the `generic` family
has no `linux--edge.config`), so those boards are not buildable, but this
repository cannot fix that from its side.

`just check-config <board>` remains the tool for a single board with a
symbol-by-symbol diff.

## Permissions

- `nix.yml`: `contents: read` only.
- `metadata-config.yml`: `contents: write`, to push the `auto/*` branch. It does
  not need `pull-requests: write` any more, since it no longer opens a PR.

## Secrets

- `CACHIX_AUTH_TOKEN`: Cachix binary cache (`havenos`). Ignored on PRs.
- `CACHIX_SIGNING_KEY`: **required** by this cache. It refuses an unsigned
  narinfo (`400 This cache requires client-side signing`) and `cachix-action`
  still reports "Pushed" — the path is simply not there afterwards. Every push
  is therefore followed by an explicit narinfo check that fails the job on
  anything but HTTP 200.
- `ATTIC_TOKEN` / `ATTIC_ENDPOINT`: Attic cache, if configured.

Without these secrets the workflows still work but rebuild more.

### The version gate

`scripts/check_kernel_versions.py` compares the `exact_version` declared in
`metadata/nix/families/*/platforms.nix` — which becomes `modDirVersion` — with
the `Makefile` at the rev `nvfetcher.lock.toml` pins. A mismatch makes the
kernel build fail after ~50 minutes with `modDirVersion ... is wrong`; the gate
catches it in a few seconds, for all 57 family/branch pairs.

It found **14 mismatches** on its first run, all pre-existing: the generator
derives the version from the branch head (`src/armbian_extractor/core.py:617`)
while the build uses the locked rev, and the `kernel-versions.json` cache is
keyed by branch (`core.py:669`), so it never invalidated when the lock moved.

`scripts/sync_kernel_versions.py` is the missing step of the pipeline: it runs
after `resolve_lock.py`, reads the `Makefile` at each pinned rev, rewrites the
single `exact_version` line, and records the value under a `source|rev` cache
key. A wrong version killed a kernel build after 50 minutes; the gate now
catches it in seconds, and it is required.

### What the cache is for

`Nix CI` builds no kernel: the six NixOS checks are `runCommand` wrappers that
write one line each (`nix/parts/checks.nix`). Caching its output would only
store a 62 MiB `metadata` copy and a 1.1 GiB devShell closure, so it pushes the
CLI package and nothing else.

`Kernel cache` fills the cache with what a user actually waits for: one
reference kernel per ARM family, built **twice** — `ubuntu-latest` produces
`packages.x86_64-linux.kernel-*` (pkgsCross), `ubuntu-24.04-arm` produces
`packages.aarch64-linux.kernel-*` (native). Those are different derivations
with different store paths: an x86 machine assembling an image asks for the
first, an ARM host for the second, and neither is served by the other's cache
entry. Measured on the same kernel: 52 min 40 s cross, 39 min 31 s native.
Each push is followed by a narinfo check.

### No automatic pull request

A refresh run pushes `auto/metadata-config` and stops. Nothing is opened on
your behalf, and the run summary prints the three commands that close the loop:

```sh
git fetch origin auto/metadata-config
git diff master...origin/auto/metadata-config
gh workflow run nix.yml --ref auto/metadata-config
gh pr create --base master --head auto/metadata-config
```

This is also the only shape that works unattended. A branch whose commits come
from `github-actions[bot]` is treated as a first-time contributor: its
`pull_request` run is parked in `action_required`, so the required `check`
never appears by itself. Dispatching `Nix CI` on the branch was measured too —
the dispatched run passes, but GitHub does not attach its check to the pull
request, so `gh pr checks` stays empty and the branch remains `BLOCKED`.

## Flake checks

`nix flake check` runs:

- `checks.metadata`: copy of `metadata/` (relative paths, no reference to the
  generation machine's store);
- `checks.metadata-clean`: fails on `/nix/store/<hash>-` or `/home/<user>/`
  paths in `metadata/` (upstream patches excluded);
- `checks.metadata-json`: every generated JSON file must parse;
- `checks.cli`: builds the Python CLI package;
- `checks.nixos-orangepizero3-edge`: NixOS module evaluation (sunxi64, H616);
- `checks.nixos-orangepizero-current`: evaluation (sunxi 32-bit, armv7l);
- `checks.nixos-rpi4b-current`: evaluation (bcm2711, Raspberry Pi 4);
- `checks.nixos-aml-a311d-cc-current`: evaluation (meson64, Amlogic);
- `checks.nixos-orangepi5-current`: evaluation (rockchip64);
- `checks.nixos-no-uboot`: board without U-Boot config (`uBoot.package = null`).

These checks evaluate the module wiring and force the kernel patch list without
building the kernel. Kernel builds and `check-hw-caps` remain separate steps:
`check-hw-caps` needs a compiled kernel, which is not part of the free CI plan.
