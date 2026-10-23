#!/usr/bin/env python3
"""Align the `dtb` of the metadata with Armbian's `BOOT_FDT_FILE`.

The generator used to read `DEFAULT_DEVICE_TREE` — the *U-Boot* device tree
name — instead of the kernel one. Two meson64 boards ended up asking for a DTB
that does not exist in the kernel (`meson-g12b-libretech-cc.dtb` instead of
`meson-g12b-a311d-libretech-cc.dtb`), and since a family builds the union of the
DTBs of all its boards, *every* meson64 kernel failed with:

    make[3]: *** No rule to make target 'arch/arm64/boot/dts/amlogic/....dtb'.

This synchronises the generated files with the value Armbian itself boots.
`metadata/all_boards_all_branches.json` already carries it, so no network is
needed. Once the generator is rerun this is a no-op.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

DTB_LINE = re.compile(r'(^\s*dtb = ")([^"]+)(";)', re.M)


def armbian_dtbs(metadata_dir: Path) -> dict[str, str]:
    """board -> BOOT_FDT_FILE, for the boards that declare one."""
    data = json.loads((metadata_dir / "all_boards_all_branches.json").read_text())
    out: dict[str, str] = {}
    for board, entry in data.items():
        value = (entry.get("BOARD_TOP_LEVEL_VARS") or {}).get("BOOT_FDT_FILE")
        if value:
            out[board] = str(value).strip()
    return out


def rewrite_board_nix(text: str, new_dtb: str) -> str:
    return DTB_LINE.sub(rf"\g<1>{new_dtb}\g<3>", text, count=1)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--metadata-dir", type=Path, default=Path("metadata"))
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    expected = armbian_dtbs(args.metadata_dir)
    changed: list[str] = []

    for path in sorted(args.metadata_dir.glob("nix/families/*/boards/*.nix")):
        board = path.name[: -len(".nix")]
        # Longest match first: `aml-a311d-cc` must not shadow `aml-a311d-cc-v2`.
        match = max(
            (b for b in expected if board.startswith(b + "-")), key=len, default=None
        )
        if match is None:
            continue
        text = path.read_text()
        line = DTB_LINE.search(text)
        if not line or line.group(2) == expected[match]:
            continue
        changed.append(f"{path.name}: {line.group(2)} -> {expected[match]}")
        if not args.dry_run:
            path.write_text(rewrite_board_nix(text, expected[match]))

    # board_metadata.json repeats the field. Round-trip it (the file is exactly
    # `json.dumps(..., indent=4)`) so the diff stays on the affected entries.
    meta_path = args.metadata_dir / "board_metadata.json"
    meta = json.loads(meta_path.read_text())
    meta_changed = False
    for entry in meta:
        board = entry.get("board")
        current = entry.get("dtb")
        if board in expected and current and current != expected[board]:
            changed.append(
                f"board_metadata.json [{board}/{entry.get('branch')}]: {current} -> {expected[board]}"
            )
            entry["dtb"] = expected[board]
            meta_changed = True
    if meta_changed and not args.dry_run:
        meta_path.write_text(json.dumps(meta, indent=4) + "\n")

    print(f"{len(changed)} valeur(s) réalignée(s)")
    for line in changed:
        print(" ", line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
