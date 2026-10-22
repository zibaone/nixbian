#!/usr/bin/env python3
"""L5 gate — check a board's module pruning.

Compare the kernel's full `modules` tree (shared per family) with the filtered
tree `kernelModules-<boardKey>` and print kept/removed + weight. Fail if
the policy produces an unusable tree (missing indexes, empty tree, no
gain) — this is the allowlist anti-regression guard.

The kernel must already be built (as for `just check-config`, no kernel
compilation is started here: the filtered derivation is cheap).

Usage: python3 scripts/check_modules.py <boardKey>
"""

import argparse
import json
import os
import subprocess
import sys


def nix(*args: str) -> str:
    result = subprocess.run(["nix", *args], capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"❌ nix {' '.join(args)} failed:\n{result.stderr.strip()}")
    return result.stdout.strip()


def tree_stats(root: str) -> tuple:
    """(number of .ko, bytes) under lib/modules/<ver>/kernel."""
    count = 0
    total = 0
    for walk_root, _, files in os.walk(root):
        for name in files:
            if ".ko" not in name:
                continue
            count += 1
            total += os.path.getsize(os.path.join(walk_root, name))
    return count, total


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("board", help="boardKey, ex. orangepizero3-edge")
    args = parser.parse_args(argv)

    full = nix("eval", "--raw", f".#kernel-{args.board}.modules")
    if not os.path.isdir(full):
        sys.exit(
            f"❌ kernel modules missing from the store ({full}) — build first "
            f"`nix build .#kernel-{args.board}`"
        )

    filtered = nix(
        "build", "--no-link", "--print-out-paths", f".#kernelModules-{args.board}"
    )
    stats_path = os.path.join(filtered, "prune-stats.json")
    if not os.path.isfile(stats_path):
        sys.exit(f"❌ {stats_path} missing: the derivation did not produce its stats")
    with open(stats_path, encoding="utf-8") as fh:
        stats = json.load(fh)

    full_root = os.path.join(full, "lib", "modules", stats["kernel_version"])
    filtered_root = os.path.join(filtered, "lib", "modules", stats["kernel_version"])
    if not os.path.isdir(full_root):
        sys.exit(f"❌ full tree not found: {full_root}")
    if not os.path.isdir(filtered_root):
        sys.exit(f"❌ filtered tree not found: {filtered_root}")
    if not os.path.isfile(os.path.join(filtered_root, "modules.dep")):
        sys.exit("❌ modules.dep absent from the filtered tree (depmod failed)")

    full_count, full_bytes = tree_stats(full_root)
    kept_count, kept_bytes = tree_stats(filtered_root)
    if (full_count, full_bytes) != (stats["total_modules"], stats["total_bytes"]):
        sys.exit(
            "❌ stats out of sync with the full tree "
            f"({stats['total_modules']}/{stats['total_bytes']} vs {full_count}/{full_bytes})"
        )
    if kept_count != stats["kept_modules"]:
        sys.exit(
            f"❌ stats out of sync with the filtered tree "
            f"({stats['kept_modules']} vs {kept_count})"
        )

    ratio = kept_bytes / full_bytes if full_bytes else 0
    print(f"L5 — {args.board} (kernel {stats['kernel_version']})")
    print(f"  DTB            : {stats['dtb']}")
    print(
        f"  compatibles    : {stats['dtb_compatibles']} (matched modules: {stats['matched_dtb_modules']})"
    )
    print(
        f"  kept           : {kept_count}/{full_count} modules, {kept_bytes / 1e6:.1f} MB ({ratio:.0%})"
    )
    print(
        f"  removed        : {stats['removed_modules']} modules, {stats['removed_bytes'] / 1e6:.1f} MB"
    )
    for item in stats["removed_top_categories"][:6]:
        print(f"    -{item['bytes'] / 1e6:5.1f} MB  {item['category']}")

    failures = []
    if kept_count == 0:
        failures.append("filtered tree is empty")
    if ratio > 0.90:
        failures.append(f"insufficient gain ({ratio:.0%} kept, 90% threshold)")
    for required in ("modules.alias", "modules.builtin"):
        if not os.path.isfile(os.path.join(filtered_root, required)):
            failures.append(f"{required} missing")
    if failures:
        for failure in failures:
            print(f"❌ {failure}")
        return 1
    print("✅ L5 gate green")
    return 0


if __name__ == "__main__":
    sys.exit(main())
