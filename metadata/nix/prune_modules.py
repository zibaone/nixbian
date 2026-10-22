#!/usr/bin/env python3
"""L5 — filter a board's shared `modules` tree (no kernel rebuild).

The kernel is built once per `(family, branch)` (57 kernels for 737 boards):
this derivation only **copies** the useful modules from an already-built tree,
then regenerates the indexes with `depmod`. The result is cacheable and
bit-identical for the same inputs.

Policy (deny-by-default):
  1. core: infrastructure subtrees (SoC, storage, USB, net, crypto, netfilter,
     fs, block, bus) always kept;
  2. board DTB compatibles -> modules via `modules.alias` (`of:`) ;
  3. `--keep`: explicitly requested module names (host allowlist);
  4. `--keep-path`: module trees whose `.ko` files are all kept
     (e.g. `boot.initrd.includeModules` on NixOS);
  5. dependency closure via `modules.dep`.

Usage:
    prune_modules.py --kernel-out <out> --modules <modules> --out <dir> \\
        [--dtb <dtb>] [--keep NAME]... [--keep-path DIR]... [--stats FILE]
"""

import argparse
import collections
import json
import os
import re
import shutil
import subprocess
import sys
from glob import glob

# Core floor (same as scripts/analyze_module_prune.py, which quantified the
# gain: 914/2637 modules kept, -78.4 MB / -57 % on orangepi-zero3).
SOCLE_PREFIXES = (
    "drivers/mmc/",
    "drivers/phy/",
    "drivers/clk/",
    "drivers/regulator/",
    "drivers/pinctrl/",
    "drivers/gpio/",
    "drivers/usb/",
    "drivers/i2c/",
    "drivers/spi/",
    "drivers/dma/",
    "drivers/soc/",
    "drivers/thermal/",
    "drivers/watchdog/",
    "drivers/rtc/",
    "drivers/nvmem/",
    "drivers/reset/",
    "drivers/bus/",
    "drivers/firmware/",
    "drivers/power/",
    "drivers/nvme/",
    "drivers/ata/",
    "drivers/scsi/",
    "drivers/net/phy/",
    "drivers/net/usb/",
    "drivers/net/ethernet/",
    "drivers/bluetooth/",
    "net/",
    "crypto/",
    "fs/",
    "kernel/",
    "lib/",
    "mm/",
    "security/",
    "block/",
)

MODULE_ALIAS_OF_RE = re.compile(r"C([A-Za-z0-9_,.+-]+)")
COMPRESSED_SUFFIXES = (".xz", ".gz", ".zst")
# Metadata copied as-is (depmod regenerates the derived indexes).
COPIED_METADATA = (
    "modules.builtin",
    "modules.builtin.modinfo",
    "modules.order",
)


def module_file(rel: str) -> bool:
    return ".ko" in os.path.basename(rel)


def module_name(path: str) -> str:
    """kmod name of a .ko path (dashes -> underscores, no extension)."""
    base = os.path.basename(path)
    for suffix in COMPRESSED_SUFFIXES:
        if base.endswith(suffix):
            base = base[: -len(suffix)]
    if not base.endswith(".ko"):
        return ""
    return base[: -len(".ko")].replace("-", "_")


def find_modules_root(modules_out: str) -> str:
    roots = glob(os.path.join(modules_out, "lib", "modules", "*"))
    roots = [r for r in roots if os.path.isdir(r)]
    if len(roots) != 1:
        sys.exit(
            f"❌ expected exactly one lib/modules/<version> in {modules_out}, found {roots}"
        )
    return roots[0]


def load_modules(root: str) -> dict:
    """{relative path from lib/modules/<ver>: size} for all .ko files."""
    kernel_dir = os.path.join(root, "kernel")
    found = {}
    for walk_root, _, files in os.walk(kernel_dir):
        for name in files:
            if not module_file(name):
                continue
            full = os.path.join(walk_root, name)
            rel = os.path.relpath(full, root)
            found[rel] = os.path.getsize(full)
    return found


def load_deps(root: str) -> dict:
    deps = {}
    path = os.path.join(root, "modules.dep")
    if not os.path.isfile(path):
        sys.exit(f"❌ {path} introuvable (tree modules incomplet ?)")
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            if ":" not in line:
                continue
            module, rest = line.split(":", 1)
            deps[module.strip()] = rest.split()
    return deps


def load_alias_map(root: str) -> dict:
    """{compatible: {nom de module}} depuis modules.alias (alias `of:`)."""
    alias_map = collections.defaultdict(set)
    path = os.path.join(root, "modules.alias")
    if not os.path.isfile(path):
        sys.exit(f"❌ {path} introuvable (tree modules incomplet ?)")
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            if not line.startswith("alias of:"):
                continue
            parts = line.split()
            if len(parts) < 3:
                continue
            for token in parts[1:-1]:
                for compat in MODULE_ALIAS_OF_RE.findall(token):
                    alias_map[compat].add(parts[-1])
    return alias_map


def dtb_compatibles(dtb: str) -> list:
    result = subprocess.run(
        ["dtc", "-I", "dtb", "-O", "dts", dtb],
        capture_output=True,
        text=True,
        check=True,
    )
    return sorted(set(re.findall(r'compatible = "([^"]+)"', result.stdout)))


def keep_path_modules(paths) -> set:
    names = set()
    for path in paths:
        for walk_root, _, files in os.walk(path):
            for name in files:
                if module_file(name):
                    available = module_name(name)
                    if available:
                        names.add(available)
    return names


def compute_keep(
    by_path: dict,
    deps: dict,
    alias_map: dict,
    compatibles: list,
    extra_keep,
    keep_paths,
) -> tuple:
    by_name = {module_name(p): p for p in by_path}
    matched = set()
    for compat in compatibles:
        for name in alias_map.get(compat, ()):
            if name in by_name:
                matched.add(by_name[name])

    requested_names = {n.replace("-", "_") for n in extra_keep}
    requested_names |= keep_path_modules(keep_paths)
    requested = {by_name[n] for n in requested_names if n in by_name}

    socle = {p for p in by_path if p[len("kernel/") :].startswith(SOCLE_PREFIXES)}

    def closure(mods):
        seen, stack = set(), list(mods)
        while stack:
            mod = stack.pop()
            if mod in seen or mod not in by_path:
                continue
            seen.add(mod)
            stack.extend(deps.get(mod, ()))
        return seen

    keep = closure(matched | requested | socle)
    return keep, matched, requested, socle


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--kernel-out", required=True)
    parser.add_argument("--modules", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--dtb", default=None)
    parser.add_argument("--keep", action="append", default=[])
    parser.add_argument("--keep-path", action="append", default=[])
    parser.add_argument("--stats", default=None)
    args = parser.parse_args(argv)

    root = find_modules_root(args.modules)
    version = os.path.basename(root)
    by_path = load_modules(root)
    if not by_path:
        sys.exit(f"❌ aucun module dans {root}")

    deps = load_deps(root)
    alias_map = load_alias_map(root)

    dtb = args.dtb
    if dtb is None:
        candidates = glob(
            os.path.join(args.kernel_out, "dtbs", "**", "*.dtb"), recursive=True
        )
        dtb = sorted(candidates)[0] if candidates else None
    compatibles = dtb_compatibles(dtb) if dtb else []

    keep, matched, requested, socle = compute_keep(
        by_path, deps, alias_map, compatibles, args.keep, args.keep_path
    )
    if not keep:
        sys.exit("❌ empty policy: no module kept (refusing to produce an empty tree)")

    out_root = os.path.join(args.out, "lib", "modules", version)
    for rel in sorted(keep):
        dest = os.path.join(out_root, rel)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(os.path.join(root, rel), dest)

    for meta in COPIED_METADATA:
        source = os.path.join(root, meta)
        if os.path.isfile(source):
            shutil.copy2(source, os.path.join(out_root, meta))

    # Regenerate modules.dep/.alias/.symbols/.softdep from the filtered tree.
    subprocess.run(["depmod", "-b", args.out, version], check=True)

    total_bytes = sum(by_path.values())
    kept_bytes = sum(by_path[rel] for rel in keep)
    removed = by_path.keys() - keep
    by_category = collections.Counter()
    for rel in removed:
        parts = rel.split("/")
        by_category[
            "/".join(parts[1:3]) if len(parts) > 2 else "/".join(parts[1:])
        ] += by_path[rel]

    stats = {
        "kernel_version": version,
        "dtb": dtb,
        "dtb_compatibles": len(compatibles),
        "matched_dtb_modules": len(matched),
        "explicitly_kept": len(requested),
        "socle_modules": len(socle),
        "total_modules": len(by_path),
        "kept_modules": len(keep),
        "removed_modules": len(removed),
        "total_bytes": total_bytes,
        "kept_bytes": kept_bytes,
        "removed_bytes": total_bytes - kept_bytes,
        "removed_top_categories": [
            {"category": cat, "bytes": size}
            for cat, size in by_category.most_common(12)
        ],
    }
    stats_path = args.stats or os.path.join(args.out, "prune-stats.json")
    os.makedirs(os.path.dirname(stats_path), exist_ok=True)
    with open(stats_path, "w", encoding="utf-8") as fh:
        json.dump(stats, fh, indent=2, sort_keys=True)
        fh.write("\n")

    print(
        f"L5 prune: {len(keep)}/{len(by_path)} modules kept, "
        f"{kept_bytes / 1e6:.1f}/{total_bytes / 1e6:.1f} MB "
        f"({100 * kept_bytes / total_bytes:.0f} %), "
        f"-{(total_bytes - kept_bytes) / 1e6:.1f} MB"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
