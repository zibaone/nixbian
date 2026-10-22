# Contributing to Nixbian

Thank you for your interest. Nixbian is an experimental project: the most useful
contributions are reproducible bug reports, tests on real hardware and fixes to
the metadata generator.

## Prerequisites

- Nix with flakes enabled (`experimental-features = nix-command flakes`);
- `just` (provided by `nix develop`);
- Python 3.10+ to run the tests outside Nix.

```bash
git clone https://github.com/zibaone/nixbian
cd nixbian
nix develop
just check
```

## Golden rule: `metadata/` is generated

**Never edit `metadata/` by hand.** This directory is produced by
`src/armbian_extractor/` from an Armbian tree pinned in `versions.json`. Every fix
must go into the generator, followed by a regeneration and a separate commit.

```bash
just refresh-metadata   # regenerate metadata/
just format             # nixfmt on the generated tree
just check              # gates
```

`just refresh-metadata` reuses `metadata/kernel-versions.json` (deterministic).
For an Armbian upgrade, force a re-read of the upstream Makefiles:

```bash
REFRESH_KERNEL_VERSIONS=1 just refresh-metadata
```

## Workflows

### Fix the generator

1. Edit `src/armbian_extractor/` (or `nix/` for the module).
2. Add a test in `tests/` that covers the real behavior (not just a mock
   evaluation).
3. `nix develop --command pytest`
4. If the output changes: `just refresh-metadata && just format`.
5. `just check`, then `nix flake check`.
6. Separate commits: `fix(generator): …`, then `chore(metadata): regenerate …`.

### Add or fix a board

1. Check that the board exists in the pinned Armbian tree
   (`config/boards/*.conf`, `config/sources/families/*.conf`).
2. Fix the generator if the extraction is incomplete.
3. Regenerate and check `metadata/nix/families/<family>/boards/`.
4. Evaluate the board:

```bash
nix eval .#orangepizero3-edge
just check-config orangepizero3-edge
```

A kernel actually compiled and tested on hardware is a much stronger validation
than an evaluation; always state what was tested.

### Documentation

Docs live in `docs/` and at the repository root (`README.md`, `CONTRIBUTING.md`,
`CHANGELOG.md`). Every claim must be measurable or traceable to a source. Avoid
untested support promises.

## Gates before a PR

```bash
just check-format
just check
nix flake check
```

`just check` includes `check-format`, `check-drift`, board evaluations, NixOS
integration tests and `pytest` (56 tests). It must **not** modify the tree:
`git status --porcelain` must stay empty after it runs.

## Commit conventions

- [Conventional Commits](https://www.conventionalcommits.org/):
  `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, `ci:`, `chore:`.
- One commit = one logical change. `metadata/` regenerations are separate from
  code fixes.
- No `amend` on a shared branch; no force-push to `master`.
- Release commits are tagged `vX.Y.Z`.

## Pull requests and direct pushes

- External contributions go through a **PR**.
- Maintainers may push directly to `master` for trivial fixes, but generator or
  metadata changes go through a PR.
- Scheduled workflows (`daily-hashes`, `weekly-armbian-upgrade`) push an
  `auto/*` branch and open a PR; they never push to `master`.

## Contribution license

By submitting a contribution, you agree that it is distributed under
**GPL-3.0-only**, the project license. Vendored patches keep their original
licenses (see `NOTICE`); do not mix incompatible code into the generator.

## Security

Do not open a public issue for a vulnerability. Follow
[`SECURITY.md`](SECURITY.md).
