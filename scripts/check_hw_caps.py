#!/usr/bin/env python3
"""Hardware capabilities gate — checks the **built** DTB, not the config.

Motivation (docs/h618-media-plan.md §1.5): nixbian built an "armbian tier"
kernel without ANY Armbian patches for months (non-recursive glob on
sets stored in subdirectories). The kernel built, `CONFIG_VIDEO_SUNXI_CEDRUS=y`
said "yes", and the DTB had neither a VE node nor an HDMI node. No test
saw it: a Kconfig option is not a hardware capability.

This script decompiles the DTB installed by the nixbian kernel and requires a list
of compatibles per board. It fails if a compatible is missing.

Usage:
    python3 scripts/check_hw_caps.py orangepizero3-edge --kernel /nix/store/...
    python3 scripts/check_hw_caps.py orangepizero3-edge            # via nix build
    python3 scripts/check_hw_caps.py --list

Exit codes: 0 = OK, 1 = missing capability, 2 = runtime error.
"""

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

# board (name without branch) -> [(expected compatible, reason)]
REQUIRED_COMPATIBLES: dict[str, list[tuple[str, str]]] = {
    "orangepizero3": [
        ("allwinner,sun50i-h616-video-engine", "Cedrus video engine (VPU)"),
        ("allwinner,sun50i-h616-dw-hdmi", "HDMI output (required for Kodi)"),
    ],
}


def _split_board_key(board_key: str) -> tuple[str, str]:
    """`orangepizero3-edge` -> (`orangepizero3`, `edge`); internal `-` preserved."""
    if "-" not in board_key:
        return board_key, ""
    board, branch = board_key.rsplit("-", 1)
    return board, branch


def _kernel_path(board_key: str, explicit: str | None) -> Path:
    if explicit:
        return Path(explicit)
    # Reproducible gate: ask nix for the store path (build if absent).
    cmd = [
        "nix",
        "build",
        "--no-link",
        "--print-out-paths",
        f".#kernel-{board_key}",
    ]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        print(f"❌ nix build failed:\n{proc.stderr.strip()}", file=sys.stderr)
        raise SystemExit(2)
    paths = [p for p in proc.stdout.split() if p]
    if not paths:
        print("❌ nix build returned no store path.", file=sys.stderr)
        raise SystemExit(2)
    return Path(paths[-1])


def _find_dtb(kernel: Path, dtb_name: str | None) -> Path:
    dtbs = sorted((kernel / "dtbs").rglob("*.dtb"))
    if dtb_name:
        matches = [d for d in dtbs if d.name == dtb_name]
        if not matches:
            print(
                f"❌ DTB {dtb_name!r} absent from {kernel}/dtbs "
                f"(available: {[d.name for d in dtbs]})",
                file=sys.stderr,
            )
            raise SystemExit(2)
        return matches[0]
    if not dtbs:
        print(f"❌ no DTB in {kernel}/dtbs", file=sys.stderr)
        raise SystemExit(2)
    if len(dtbs) > 1:
        # Normal outside sunxi64 (filtered dtb_list): then require --dtb.
        print(
            "❌ multiple DTBs installed "
            f"({[str(d.relative_to(kernel / 'dtbs')) for d in dtbs]}): "
            "specify --dtb.",
            file=sys.stderr,
        )
        raise SystemExit(2)
    return dtbs[0]


def _own_block(block: str) -> str:
    """Node's own content: remove sub-nodes (nested blocks).

    We work on the INSIDE of the block: otherwise the regex `\\{[^{}]*\\}` includes
    the node itself when it has no child and erases its properties.
    """
    inner = block[1:-1] if block.startswith("{") else block
    prev = None
    own = inner
    while prev != own:
        prev = own
        own = re.sub(r"\{[^{}]*\}", "{}", own)
    return own


def _node_state(dts: str, compatible: str) -> str:
    """State of a node carrying `compatible`: absent | disabled | okay.

    A node may be declared in the dtsi then left `status = "disabled"`;
    enabling it is the board patch's job (e.g. Armbian `patches.drm/0043` for
    the Orange Pi Zero 3 HDMI). A simple grep of the compatible does not see it.
    """
    if compatible not in dts:
        return "absent"
    # Balanced `{...}` blocks in one pass, then the smallest block whose
    # OWN content (excluding sub-nodes) carries the compatible = the node itself.
    stack: list[int] = []
    owning: tuple[int, int] | None = None
    for i, ch in enumerate(dts):
        if ch == "{":
            stack.append(i)
        elif ch == "}" and stack:
            start = stack.pop()
            if owning is not None and (i - start) >= (owning[1] - owning[0]):
                continue
            block = dts[start : i + 1]
            if compatible not in block:
                continue
            if compatible in _own_block(block):
                owning = (start, i)
    if owning is None:
        return "absent"
    own = _own_block(dts[owning[0] : owning[1] + 1])
    return "disabled" if re.search(r'status\s*=\s*"disabled"', own) else "okay"


def _dtx(dtb: Path) -> str:
    if shutil.which("dtc") is None:
        print(
            "❌ dtc not found in PATH (nix shell nixpkgs#dtc -c …)",
            file=sys.stderr,
        )
        raise SystemExit(2)
    proc = subprocess.run(
        ["dtc", "-I", "dtb", "-O", "dts", "-q", str(dtb)],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(f"❌ dtc failed:\n{proc.stderr.strip()}", file=sys.stderr)
        raise SystemExit(2)
    return proc.stdout


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        prog="check-hw-caps",
        description="Checks the expected hardware compatibles in a board's DTB.",
    )
    parser.add_argument(
        "board", nargs="?", help="boardKey nixbian, ex. orangepizero3-edge"
    )
    parser.add_argument(
        "--kernel", help="nixbian kernel store path (otherwise nix build)"
    )
    parser.add_argument("--dtb", help="exact DTB name when several are installed")
    parser.add_argument(
        "--list", action="store_true", help="lists the covered boards"
    )
    args = parser.parse_args(argv)

    if args.list:
        for board, reqs in sorted(REQUIRED_COMPATIBLES.items()):
            print(f"{board}:")
            for compat, why in reqs:
                print(f"  - {compat}  ({why})")
        return 0

    if not args.board:
        parser.error("board required (or --list)")

    board, _branch = _split_board_key(args.board)
    required = REQUIRED_COMPATIBLES.get(board)
    if not required:
        print(
            f"ℹ️  no capability required for {board!r} — gate not applicable "
            f"(covered boards: {sorted(REQUIRED_COMPATIBLES)})"
        )
        return 0

    kernel = _kernel_path(args.board, args.kernel)
    dtb = _find_dtb(kernel, args.dtb)
    dts = _dtx(dtb)

    print(f"kernel : {kernel}")
    print(f"dtb    : {dtb.relative_to(kernel) if kernel in dtb.parents else dtb}")

    bad: list[tuple[str, str]] = []
    for compat, why in required:
        state = _node_state(dts, compat)
        if state == "okay":
            print(f"  ✅ {compat}  ({why})")
        elif state == "disabled":
            print(
                f'  ❌ {compat}  ({why}) — node present but status = "disabled" '
                "(board patch was not applied)"
            )
            bad.append((compat, state))
        else:
            print(f"  ❌ {compat}  ({why}) — node absent from the DTB")
            bad.append((compat, state))

    if bad:
        print(
            "\n❌ Incomplete DTB: the platform patches are probably not "
            "applied (see docs/h618-media-plan.md §1.5). Check the number of "
            "patches in the derivation:\n"
            "  nix derivation show $(nix eval --raw '.#kernel-"
            f"{args.board}.drvPath') | jq '.derivations[].structuredAttrs.patches | length'",
            file=sys.stderr,
        )
        return 1

    print("\n✅ hardware capabilities present in the DTB.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
