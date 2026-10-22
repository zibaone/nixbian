#!/usr/bin/env python3
"""Nixbian kernel configuration gate (no compilation).

Behavior depends on the kernel's effective tier (`kernel.configMode`, exposed by
the generated lib):

  * `armbian` — the family .config is passed as-is to linuxManualConfig
    (`ln -sv` + `make oldconfig`). The gate builds this file and checks that it
    is indeed the family reference config (wiring). Convergence
    after `make oldconfig` is only proven by a real build.
  * `defconfig` — the Armbian config is not applied by design; the gate
    checks that the family fragment symbols (.config Nix) are actually
    applied in the generated .config.
  * `nixpkgs` — common nixpkgs config: gate not applicable.

Usage:
    python3 scripts/check_config.py <boardKey>
    python3 scripts/check_config.py <boardKey> --kernel-config /path/.config  # no nix build
    python3 scripts/check_config.py <boardKey> --metadata-dir metadata

Exit codes:
    0 — no divergence (or gate not applicable: no reference config for the platform)
    1 — at least one diverging symbol
    2 — runtime error (unknown board, nix build failed, config ambiguity, ...)
"""

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Symbols tracked by the gate: only boolean/module activations.
SYMBOL_RE = re.compile(r"^CONFIG_[A-Z0-9_]+=([ym])$")

# Reference to a config file in the generated Nix: configs/<name>.config
CONFIG_REF_RE = re.compile(r'configs/([A-Za-z0-9_.+@-]+\.config)"')


class ConfigGateError(RuntimeError):
    """Gate runtime error (≠ config divergence)."""


def parse_config_symbols(text: str) -> dict:
    """Extract CONFIG_*=y|m symbols from a .config (last occurrence wins)."""
    symbols = {}
    for raw in text.splitlines():
        line = raw.strip()
        if SYMBOL_RE.match(line):
            symbol, value = line.split("=", 1)
            symbols[symbol] = value
    return symbols


def compare_symbols(reference: dict, generated: dict) -> list:
    """Return divergences [(symbol, expected, found|None)] sorted by symbol.

    The comparison is one-way: only symbols from the reference config
    (Armbian) are checked. Extra symbols brought
    by the platform defconfig are normal.
    """
    divergent = []
    for symbol in sorted(reference):
        expected = reference[symbol]
        found = generated.get(symbol)
        if found != expected:
            divergent.append((symbol, expected, found))
    return divergent


def _report_divergences(divergent: list, reference_count: int, max_examples: int) -> int:
    """Print divergences and return exit code 1."""
    print(f"❌ {len(divergent)} diverging symbol(s) out of {reference_count}:")
    for symbol, expected, found in divergent[:max_examples]:
        if found is None:
            detail = f"missing from generated .config (expected {expected})"
        else:
            detail = f"expected {expected}, found {found}"
        print(f"   - {symbol} : {detail}")
    if len(divergent) > max_examples:
        print(f"   … and {len(divergent) - max_examples} more (see --max-examples)")
    return 1


def find_family_config(
    metadata_dir: Path, family: str, branch: str, board_key: str = None
):
    """Locate the raw Armbian config for a platform (or None if none).

    Resolution order:
      1. board override: `families/<fam>/boards/<boardKey>.nix` (config_path_nix field)
      2. `families/<fam>/configs/linux-<fam>-<branch>.config`
      3. `families/<fam>/configs/<fam>-<branch>.config`
      4. single glob `families/<fam>/configs/*<fam>-<branch>*.config`
    """
    configs_dir = metadata_dir / "nix" / "families" / family / "configs"

    if board_key:
        board_file = (
            metadata_dir / "nix" / "families" / family / "boards" / f"{board_key}.nix"
        )
        if board_file.is_file():
            match = CONFIG_REF_RE.search(board_file.read_text(encoding="utf-8"))
            if match and (configs_dir / match.group(1)).is_file():
                return configs_dir / match.group(1)

    if configs_dir.is_dir():
        for name in (f"linux-{family}-{branch}.config", f"{family}-{branch}.config"):
            candidate = configs_dir / name
            if candidate.is_file():
                return candidate
        matches = sorted(
            p for p in configs_dir.glob("*.config") if f"{family}-{branch}" in p.name
        )
        if len(matches) == 1:
            return matches[0]
        if len(matches) > 1:
            listing = ", ".join(p.name for p in matches)
            raise ConfigGateError(
                f"multiple candidate configs for {family}-{branch}: {listing}"
            )
    return None


def build_kernel_configfile(board_key: str) -> Path:
    """Build `.#kernel-<boardKey>.configfile` (no compilation) and return the path."""
    cmd = [
        "nix",
        "build",
        "--no-link",
        "--print-out-paths",
        f".#kernel-{board_key}.configfile",
    ]
    print("🔧 " + " ".join(cmd))
    proc = subprocess.run(cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    if proc.returncode != 0:
        tail = "\n".join((proc.stderr or proc.stdout or "").splitlines()[-15:])
        raise ConfigGateError(
            f"`nix build .#kernel-{board_key}.configfile` failed (code {proc.returncode}):\n{tail}"
        )
    paths = [line.strip() for line in proc.stdout.splitlines() if line.strip()]
    if not paths:
        raise ConfigGateError(
            "nix build printed no output path (--print-out-paths)."
        )
    return Path(paths[-1])


def eval_kernel_attr(board_attr: str, attr: str):
    """Evaluate `.#kernel-<board_attr>.<attr>` (string) — None if absent/failure.

    Fallback to `passthru.<attr>`: some introspection attributes only exist
    in the generated kernel's passthru.
    """
    for installable in (
        f".#kernel-{board_attr}.{attr}",
        f".#kernel-{board_attr}.passthru.{attr}",
    ):
        proc = subprocess.run(
            ["nix", "eval", "--raw", installable],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
        )
        if proc.returncode == 0:
            value = proc.stdout.strip()
            if value:
                return value
    return None


def _display(path: Path) -> str:
    try:
        return str(path.relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        prog="check-config",
        description=(
            "Configuration gate: checks that the family's Armbian config is "
            "actually applied by the armbian tier (builds the .config only)."
        ),
    )
    parser.add_argument("board", help="boardKey, ex: orangepizero3-current")
    parser.add_argument(
        "--metadata-dir",
        default=str(REPO_ROOT / "metadata"),
        help="metadata directory (default: <repo>/metadata)",
    )
    parser.add_argument(
        "--kernel-config",
        help="path to an already generated .config — skips the nix build (debug / tests)",
    )
    parser.add_argument(
        "--max-examples",
        type=int,
        default=20,
        help="number of divergence examples displayed (default: 20)",
    )
    args = parser.parse_args(argv)

    metadata_dir = Path(args.metadata_dir).resolve()

    # 1. Locate the board.
    boards_file = metadata_dir / "boards.json"
    if not boards_file.is_file():
        print(f"❌ {boards_file} not found.", file=sys.stderr)
        return 2
    # Tier variant: `kernel-<boardKey>-defconfig`. The boardKey alone remains the key
    # in boards.json; the suffix selects the package to inspect.
    variant = ""
    board_key = args.board
    if board_key.endswith("-defconfig"):
        board_key = board_key[: -len("-defconfig")]
        variant = "-defconfig"
    target = f"{board_key}{variant}"

    boards = json.loads(boards_file.read_text(encoding="utf-8"))
    if board_key not in boards:
        print(
            f"❌ unknown boardKey: {board_key!r} (absent from {_display(boards_file)})",
            file=sys.stderr,
        )
        suggestions = [k for k in sorted(boards) if board_key.split("-")[0] in k][:10]
        if suggestions:
            print("   Close matches: " + ", ".join(suggestions), file=sys.stderr)
        return 2
    info = boards[board_key]
    family = info["family"]
    branch = info["branch"]
    print(
        f"📋 Board: {args.board} "
        f"(family={family}, branch={branch}, arch={info.get('arch', '?')})"
    )

    # 2. Armbian reference config.
    try:
        reference_path = find_family_config(
            metadata_dir, family, branch, board_key=board_key
        )
    except ConfigGateError as exc:
        print(f"❌ {exc}", file=sys.stderr)
        return 2
    if reference_path is None:
        print(
            "ℹ️  No reference Armbian config found for this family/branch."
        )
        configs_dir = metadata_dir / "nix" / "families" / family / "configs"
        if configs_dir.is_dir():
            available = ", ".join(sorted(p.name for p in configs_dir.glob("*.config")))
            print(
                f"   Files available in {_display(configs_dir)}: {available or '(none)'}"
            )
        else:
            print(f"   (no directory {_display(configs_dir)})")
        print("   → armbian mode applies no fragment here; gate not applicable.")
        return 0
    reference = parse_config_symbols(reference_path.read_text(encoding="utf-8"))
    print(
        f"📄 Armbian reference: {_display(reference_path)} ({len(reference)} symbols =y|m)"
    )

    # 2bis. Configuration tier actually applied (kernel.configMode attribute).
    mode = eval_kernel_attr(target, "configMode")
    if mode:
        print(f"⚙️  Effective config tier: {mode}")
    if mode == "armbian" and not args.kernel_config:
        # armbian tier: the family .config is passed as `configfile` to
        # linuxManualConfig (ln -sv + make oldconfig). We build this file and
        # check that it is indeed identical to the reference config.
        try:
            applied_str = eval_kernel_attr(target, "configfile")
            applied_path = Path(applied_str) if applied_str else None
            if applied_path is None or not applied_path.is_file():
                applied_path = build_kernel_configfile(target)
        except ConfigGateError as exc:
            print(f"❌ {exc}", file=sys.stderr)
            return 2
        print(f"🧾 applied config: {applied_path}")
        applied_text = applied_path.read_text(encoding="utf-8")
        if applied_text != reference_path.read_text(encoding="utf-8"):
            generated = parse_config_symbols(applied_text)
            divergent = compare_symbols(reference, generated)
            if divergent:
                return _report_divergences(divergent, len(reference), args.max_examples)
            print(
                "⚠️  Applied config ≠ reference byte-for-byte, but same symbols =y|m."
            )
        print(
            f"✅ Tier armbian: applied config identical to the reference "
            f"({len(parse_config_symbols(applied_text))} symbols =y|m)."
        )
        print(
            "   ℹ️  The gate checks the wiring (which config is applied); the "
            "convergence after `make oldconfig` requires a real build."
        )
        return 0

    # 3. Generated .config (configfile build only, no compilation).
    if args.kernel_config:
        kernel_config_path = Path(args.kernel_config).resolve()
        print(f"🧾 .config provided : {_display(kernel_config_path)}")
    else:
        try:
            kernel_config_path = build_kernel_configfile(target)
        except ConfigGateError as exc:
            print(f"❌ {exc}", file=sys.stderr)
            return 2
        print(f"🧾 generated .config: {kernel_config_path}")
    if kernel_config_path.is_dir():
        kernel_config_path = kernel_config_path / ".config"
    if not kernel_config_path.is_file():
        print(f"❌ .config not found: {kernel_config_path}", file=sys.stderr)
        return 2
    generated = parse_config_symbols(kernel_config_path.read_text(encoding="utf-8"))
    print(f"   → {len(generated)} symbols =y|m in the generated .config")

    # 4. Interpretation according to the effective tier.
    if mode == "defconfig":
        # defconfig tier: the Armbian config is NOT applied (by design);
        # we check that the family fragment is applied, symbol by symbol.
        fragment = eval_kernel_attr(target, "configFragment")
        if not fragment:
            print("ℹ️  defconfig tier with no family fragment exposed — gate not applicable.")
            return 0
        wanted = parse_config_symbols(fragment)
        missing = [
            (symbol, expected, generated.get(symbol))
            for symbol, expected in sorted(wanted.items())
            if generated.get(symbol) != expected
        ]
        if missing:
            print(
                f"❌ defconfig tier: {len(missing)} symbol(s) from the family fragment "
                f"not applied out of {len(wanted)}:"
            )
            for symbol, expected, found in missing[: args.max_examples]:
                detail = (
                    "missing from generated .config"
                    if found is None
                    else f"expected {expected}, found {found}"
                )
                print(f"   - {symbol} : {detail}")
            return 1
        print(
            f"✅ defconfig tier: all {len(wanted)} symbols from the family fragment are applied."
        )
        print(
            "   ℹ️  The defconfig tier does not apply the full Armbian config "
            "(`just check-config` vs armbian: not applicable)."
        )
        return 0

    if mode == "nixpkgs":
        print(
            "ℹ️  nixpkgs tier: common nixpkgs config (the Armbian config is not "
            "applied by design) — gate not applicable."
        )
        return 0

    # 5. Comparison vs Armbian config (legacy armbian tier / lib without configMode).
    divergent = compare_symbols(reference, generated)
    if not divergent:
        print(
            f"✅ Config compliant: all {len(reference)} Armbian symbols are applied without divergence."
        )
        return 0
    return _report_divergences(divergent, len(reference), args.max_examples)


if __name__ == "__main__":
    sys.exit(main())
