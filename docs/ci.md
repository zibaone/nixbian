# CI and automation

## Workflows

| File | Trigger | Role |
| --- | --- | --- |
| `.github/workflows/nix.yml` | PR, push to `main`/`master` | `nix flake check` (metadata checks + 6 board evaluations + CLI), `just check-format`, `just check-drift`, `pytest` |
| `.github/workflows/daily-hashes.yml` | cron `0 6 * * *`, manual | `scripts/resolve_lock.py`, commit to `auto/weekly-hashes`, open/update a PR |
| `.github/workflows/weekly-armbian-upgrade.yml` | cron `0 6 * * 4` (Thursday), manual | `update-versions` + `refresh-metadata` (with kernel version refresh), `resolve_lock.py`, PR `auto/armbian-upgrade` |

Scheduled jobs **never** push to `master`: they push an `auto/*` branch and open
a PR. Merging remains a human decision.

## Permissions

- `nix.yml`: `contents: read` only.
- Cron workflows: `contents: write` (push the `auto/*` branch) and
  `pull-requests: write` (create/update the PR).
- `GITHUB_TOKEN` is provided by GitHub Actions; no extra PAT is required to open
  a PR in the same repository.

## Optional secrets

- `CACHIX_AUTH_TOKEN`: Cachix binary cache (`havenos`). Ignored on PRs.
- `ATTIC_TOKEN` / `ATTIC_ENDPOINT`: Attic cache, if configured.

Without these secrets the workflows still work but rebuild more.

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
building the kernel. Kernel builds, `check-config` and `check-hw-caps` remain
separate CI steps.
