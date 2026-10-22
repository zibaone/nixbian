# Changelog

All notable changes to Nixbian are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
the project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.3.0] - 2026-10-22

First public release, prepared from a cleaned tree (new git history, without
session notes or internal archives).

### Added

- `flake.checks`: `checks.metadata`, `checks.metadata-clean`,
  `checks.metadata-json`, `checks.cli`, and six NixOS evaluations
  (`orangepizero3-edge`, `orangepizero-current`, `rpi4b-current`,
  `aml-a311d-cc-current`, `orangepi5-current`, `phytiumpi-current` without
  U-Boot).
- Deterministic cache `metadata/kernel-versions.json`; option
  `--refresh-kernel-versions` / `REFRESH_KERNEL_VERSIONS=1` for upgrades.
- Tests for the kernel cache, relative paths and patch-name sanitization
  (56 tests).
- `CONTRIBUTING.md`, `CHANGELOG.md`, `NOTICE`, `SECURITY.md`, `docs/ci.md`.
- Dependabot for GitHub Actions and pip.

### Changed

- Metadata now emits paths **relative** to the Armbian tree
  (`config_path`, `target_map`, `atf_target_map`) instead of
  `/nix/store/…` paths from the generation machine.
- `metadata/` is formatted with `nixfmt`; `just check-format` checks without
  rewriting the tree.
- The `all_boards_all_branches.json` and `all_userspace_inventory.json`
  inventories have distinct schemas (the 547 KiB duplicate is gone).
- CI: minimal permissions, scheduled jobs on `auto/*` branches with PRs.
- Project version: `0.3.0` (tags `v0.1.0` and `v0.2.0` predate this release).

### Fixed

- Stale families and boards are pruned during regeneration: orphan files no
  longer keep store paths.
- Patch names containing `&` or `,` are sanitized for Nix
  (`sanitize_patch_name`), without changing content or `series.conf` order.
- `just check` no longer modifies the tree and actually fails on a badly
  formatted file (negative test).

### Removed

- Internal session notes and working archives are not part of the public tree
  (kept in the private history).
- Obsolete inventory dumps and families absent from Armbian v26.5.1.

[Unreleased]: https://github.com/zibaone/nixbian/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/zibaone/nixbian/releases/tag/v0.3.0
