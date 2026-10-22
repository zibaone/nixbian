# CI and automation

## Workflows

| File | Trigger | Role |
| --- | --- | --- |
| `.github/workflows/nix.yml` | PR, push to `main`/`master` | `nix flake check` (metadata checks + 6 board evaluations + CLI), `just check-format`, `just check-drift`, `pytest`, the kernel config gate over every family/branch pair, `just check` |
| `.github/workflows/metadata-config.yml` | cron `0 7 * * *`, manual | Single owner of the generated state: `update-versions` (new Armbian tags), `refresh-metadata` (regeneration, with kernel version refresh), `scripts/resolve_lock.py` (hashes), `scripts/check_all_configs.py` (gate), PR `auto/metadata-config` |

Scheduled jobs **never** push to `master`: they push an `auto/*` branch and open
a PR. Merging remains a human decision.

There is one scheduled workflow on purpose. `versions.json`, `metadata/` and
the nvfetcher hashes are produced by the same generator run, so splitting them
across several crons means several branches competing over the same files.

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
- `metadata-config.yml`: `contents: write` (push the `auto/*` branch) and
  `pull-requests: write` (create/update the PR).

## Secrets

- `AUTO_PR_TOKEN` (**optional, preferred**): a fine-grained personal access
  token scoped to this repository, with `Contents: write` and
  `Pull requests: write`. When present, the pull request is opened as a user
  and triggers `Nix CI` on its own.
- `CACHIX_AUTH_TOKEN`: Cachix binary cache (`havenos`). Ignored on PRs.
- `ATTIC_TOKEN` / `ATTIC_ENDPOINT`: Attic cache, if configured.

Without the cache secrets the workflows still work but rebuild more.

### Why the bot needs a hand to get its PR checked

GitHub never starts a workflow run from an event caused by `GITHUB_TOKEN`.
A pull request opened by the bot therefore never receives the required
`check` status. `workflow_dispatch` is the documented exception to that rule,
so `metadata-config.yml` dispatches `Nix CI` on the `auto/metadata-config`
branch after opening the PR: the dispatched run's check attaches to the
branch head, which is the PR head.

This path also requires the repository setting *Allow GitHub Actions to create
and approve pull requests* (`can_approve_pull_request_reviews`), otherwise
`gh pr create` fails with a 403. Both mechanisms become unnecessary once
`AUTO_PR_TOKEN` is set.

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
