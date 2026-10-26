#!/usr/bin/env python3
"""Family-wide configuration gate — one evaluation, every board.

`scripts/check_config.py` checks a single board: it resolves the family's
Armbian reference config, then builds `.#kernel-<boardKey>.configfile` and
compares the two symbol by symbol. That is the right check for one board,
but it costs one `nix build` + two `nix eval` per invocation.

This script covers the same ground for **every** board in one pass, because
the wiring is not per board. The generated `metadata/nix/families/<fam>/
platforms.nix` maps a `family-branch` pair to a single kernel package, and
every board of that pair shares the same Armbian config.
`metadata/boards.json` holds 737 boards but only 57 `family+branch` pairs,
covered by 53 reference configs.

Strategy:

1. One `nix eval` extracts, for every `kernel-*` attribute of the flake:
   the effective tier (`configMode`) and the applied config file
   (`configfile`).
2. The reference config of each `family+branch` pair is read from
   `platforms.nix` (`config_path_nix`), which is the generator's own
   mapping — not a filename convention.
3. Every pair in the `armbian` tier must apply its reference config
   verbatim (byte-for-byte).

Boards in the `defconfig` or `nixpkgs` tier have no Armbian config to
check by design; they are counted and reported, not failed.

Usage:
    python3 scripts/check_all_configs.py
    python3 scripts/check_all_configs.py --metadata-dir metadata
    python3 scripts/check_all_configs.py --system aarch64-linux

Exit codes: 0 = all tiers consistent, 1 = at least one divergence,
2 = runtime error (flake evaluation failed, metadata missing, ...).
"""

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# `config_path_nix = "configs/linux-uefi-arm64-cloud.config";`
CONFIG_PATH_RE = re.compile(r'config_path_nix\s*=\s*"([^"]+)"')
# `familyExtraConfig = "CONFIG_PSI=y\nCONFIG_...=y\n";` (armbian tier)
FAMILY_EXTRA_RE = re.compile(r'familyExtraConfig\s*=\s*"((?:[^"\\]|\\.)*)";')
# A platform block header: `  "<family-branch>" = {`
PLATFORM_ATTR_RE = re.compile(r'^\s*"([^"]+)"\s*=\s*\{')

TIER_LABELS = {
    "armbian": "Armbian config applied (checked)",
    "defconfig": "defconfig tier (family fragment, not checked here)",
    "nixpkgs": "nixpkgs tier (no Armbian config by design)",
}


class GateError(RuntimeError):
    """Gate runtime error (not a configuration divergence)."""


def eval_kernel_wiring(system: str) -> dict:
    """Return {boardKey: {mode, configfile}} for every `kernel-*` attribute.

    A single `nix eval` covers the whole flake: evaluating the attribute
    set is what costs, not the number of attributes.
    """
    expr = (
        "p: builtins.listToAttrs (map (n: { name = n; value = { "
        "mode = p.${n}.configMode or null; "
        "cfg = if p.${n} ? configfile then toString p.${n}.configfile "
        "else null; }; }) "
        '(builtins.filter (x: builtins.match "kernel-.*" x != null) '
        "(builtins.attrNames p)))"
    )
    cmd = ["nix", "eval", "--json", f".#packages.{system}", "--apply", expr]
    proc = subprocess.run(cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    if proc.returncode != 0:
        tail = "\n".join((proc.stderr or proc.stdout or "").splitlines()[-15:])
        raise GateError(f"`{' '.join(cmd)}` failed (code {proc.returncode}):\n{tail}")
    try:
        return json.loads(proc.stdout)
    except json.JSONDecodeError as exc:
        raise GateError(f"could not parse the flake evaluation output: {exc}") from exc


def collect_reference_configs(metadata_dir: Path) -> dict:
    """Return {family-branch: {"path": reference .config, "extra": str}}.

    The mapping is read from the generated `platforms.nix` of each family:
    the attribute name is the `family-branch` pair and `config_path_nix`
    is the path of the Armbian config relative to the family directory.
    `familyExtraConfig` (nixbian's own lines, armbian tier) is the suffix
    the applied config is expected to carry after the reference.
    """
    families_dir = Path(metadata_dir) / "nix" / "families"
    if not families_dir.is_dir():
        raise GateError(f"{families_dir} not found (metadata missing?)")

    refs: dict[str, dict] = {}
    for family_dir in sorted(families_dir.iterdir()):
        platforms_file = family_dir / "platforms.nix"
        if not platforms_file.is_file():
            continue
        text = platforms_file.read_text(encoding="utf-8")
        # Line-based scan: a platform block starts with `  "<name>" = {`
        # and its config path is the `config_path_nix` entry of that block.
        current: str | None = None
        for line in text.splitlines():
            name_match = PLATFORM_ATTR_RE.match(line)
            if name_match:
                current = name_match.group(1)
                continue
            config_match = CONFIG_PATH_RE.search(line)
            if config_match and current:
                value = {
                    "path": Path(family_dir) / config_match.group(1),
                    "extra": "",
                }
                refs[current] = value
                current = None

    # Family lines: declarative source, copied verbatim next to library.nix by
    # write_library_nix(). Keyed by platform (family-branch), like platforms.nix.
    lines_file = Path(metadata_dir) / "nix" / "family_config.json"
    if lines_file.is_file():
        declared = json.loads(lines_file.read_text(encoding="utf-8"))
        for platform, lines in declared.items():
            if platform.startswith("_") or platform not in refs:
                continue
            refs[platform]["extra"] = "\n".join(lines) + "\n"
    return refs


def audit(boards: dict, wiring: dict, refs: dict) -> dict:
    """Compare the flake wiring with the reference configs, pair by pair.

    Pure function: no IO, no subprocess. Returns the tier counts, the
    verified pairs, the warnings (a pair without any kernel package) and
    the problems (real divergences).
    """
    pairs: dict[str, list[str]] = {}
    for board_key, info in boards.items():
        pair = f"{info['family']}-{info['branch']}"
        pairs.setdefault(pair, []).append(board_key)

    tiers: dict[str, int] = {}
    problems: list[str] = []
    warnings: list[str] = []
    verified: dict[str, str] = {}

    for pair in sorted(pairs):
        board_keys = pairs[pair]
        # A pair is covered by any of its boards: the kernel package is
        # shared, so one evaluation decides for all of them.
        sample = board_keys[0]
        attr = f"kernel-{sample}"
        info = wiring.get(attr)
        if info is None:
            # No kernel package at all for this pair. Upstream Armbian
            # sometimes ships a branch without a config file (the
            # `generic` family has no `linux--edge.config`), so the
            # generator emits a platform with no usable kernel. Nothing
            # to verify here, but those boards are not buildable: report
            # it loudly instead of failing a gate this side cannot fix.
            warnings.append(
                f"{pair}: no `{attr}` attribute in the flake "
                f"({len(board_keys)} board(s) affected, "
                "no reference config upstream)"
            )
            continue

        mode = info.get("mode")
        tiers[mode or "unknown"] = tiers.get(mode or "unknown", 0) + len(board_keys)

        if mode != "armbian":
            # defconfig / nixpkgs tiers have no Armbian config to check.
            continue

        applied = info.get("cfg")
        if not applied:
            problems.append(f"{pair}: tier armbian but no configfile exposed")
            continue

        ref = refs.get(pair)
        if ref is None:
            problems.append(
                f"{pair}: no reference config in platforms.nix "
                f"({len(board_keys)} board(s) affected)"
            )
            continue

        applied_path = Path(applied)
        # `refs` carries {"path", "extra"} from collect_reference_configs();
        # a bare Path is still accepted so the audit stays usable on its own.
        if isinstance(ref, dict):
            ref_path = Path(ref["path"])
            family_extra = ref.get("extra") or ""
        else:
            ref_path = Path(ref)
            family_extra = ""
        if not applied_path.is_file():
            problems.append(f"{pair}: applied config not found: {applied_path}")
            continue
        if not ref_path.is_file():
            problems.append(f"{pair}: reference config not found: {ref_path}")
            continue

        verified[pair] = str(ref_path)
        # The armbian tier concatenates, in this order, the reference config,
        # nixbian's family lines and the user override (template library.nix).
        expected = ref_path.read_bytes()
        if family_extra:
            expected += b"\n" + family_extra.encode() + b"\n"
        if applied_path.read_bytes() != expected:
            problems.append(
                f"{pair}: applied config differs from the reference "
                f"(+ family lines) ({len(board_keys)} board(s) "
                f"affected): {applied_path} != {ref_path}"
            )

    return {
        "pairs": pairs,
        "tiers": tiers,
        "verified": verified,
        "boards_verified": sum(len(pairs[name]) for name in verified),
        "warnings": warnings,
        "problems": problems,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        prog="check-all-configs",
        description=(
            "Family-wide configuration gate: one flake evaluation, every board."
        ),
    )
    parser.add_argument(
        "--metadata-dir",
        default=str(REPO_ROOT / "metadata"),
        help="metadata directory (default: <repo>/metadata)",
    )
    parser.add_argument(
        "--system",
        default="x86_64-linux",
        help="flake system to evaluate (default: x86_64-linux)",
    )
    args = parser.parse_args(argv)

    metadata_dir = Path(args.metadata_dir).resolve()

    boards_file = metadata_dir / "boards.json"
    if not boards_file.is_file():
        print(f"❌ {boards_file} not found.", file=sys.stderr)
        return 2

    try:
        wiring = eval_kernel_wiring(args.system)
    except GateError as exc:
        print(f"❌ {exc}", file=sys.stderr)
        return 2

    try:
        refs = collect_reference_configs(metadata_dir)
    except GateError as exc:
        print(f"❌ {exc}", file=sys.stderr)
        return 2

    boards = json.loads(boards_file.read_text(encoding="utf-8"))
    print(f"📋 Boards in metadata: {len(boards)}")
    print(f"🔌 Kernel attributes evaluated: {len(wiring)}")
    print(f"📄 Reference configs mapped: {len(refs)}")

    result = audit(boards, wiring, refs)

    print()
    for mode, count in sorted(result["tiers"].items()):
        print(f"   {count:4d} board(s) — {TIER_LABELS.get(mode, mode)}")

    print(
        f"✅ {len(result['verified'])} family/branch pair(s) verified "
        f"({result['boards_verified']} board(s)), config applied verbatim."
    )

    if result["warnings"]:
        print(f"\n⚠️  {len(result['warnings'])} pair(s) without a kernel package:")
        for warning in result["warnings"]:
            print(f"   - {warning}")

    if result["problems"]:
        print(f"\n❌ {len(result['problems'])} problem(s):", file=sys.stderr)
        for problem in result["problems"]:
            print(f"   - {problem}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
