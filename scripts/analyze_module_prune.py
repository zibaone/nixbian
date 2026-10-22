#!/usr/bin/env python3
"""Dry-run analysis of kernel module pruning (L5 plan) — READ ONLY.

Goal: quantify, before any implementation, what pruning the `modules` tree
would remove for a given board — without rebuilding the kernel (we work on
the existing `modules` output) and without touching the Armbian config.

Method
  1. board DTB compatibles (via `dtc`);
  2. compatible → module mapping via `modules.alias` (`of:` aliases);
  3. dependency closure via `modules.dep`;
  4. base floor: subtrees always kept (SoC infra, storage,
     network, crypto, netfilter, fs).
Two scenarios are quantified:
  A = DTB + closure only;
  B = A + base floor.

Findings as of 2026-10-19 (armbian tier, sunxi64-edge, orangepi-zero3):
  - A ≈ 3 modules: the board drivers are **built-in** (`=y`) in the
    Armbian config, hence absent from `modules.alias` → the DTB-only rule
    reports almost nothing; the policy must be "base + allowlist";
  - B keeps ~910/2637 modules (~58/136 MB) → ~79 MB removed (~58 %), dominated by
    drivers/net (wireless from other boards), iio, media, gpu, hwmon, input.

Usage:
    python3 scripts/analyze_module_prune.py <kernel-out> <modules-out>

Example (artifacts from the first build):
    python3 scripts/analyze_module_prune.py \\
      /nix/store/k9rac2p5…-linux-aarch64-unknown-linux-gnu-7.0.14 \\
      /nix/store/hrcqs7iy…-linux-aarch64-unknown-linux-gnu-7.0.14-modules
"""

import collections
import os
import re
import subprocess
import sys
from glob import glob

# Base floor: subtrees always kept (SoC infra, storage,
# network, crypto, netfilter, filesystems, block, bus).
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


def module_name(path: str) -> str:
    """kmod name of a .ko path (dashes → underscores, no extension)."""
    return os.path.basename(path)[: -len(".ko")].replace("-", "_")


def load_alias_map(modules_root: str) -> dict:
    """{compatible: {module name}} from modules.alias (`of:` aliases)."""
    alias_map = collections.defaultdict(set)
    alias_path = os.path.join(modules_root, "modules.alias")
    if not os.path.isfile(alias_path):
        sys.exit(f"❌ {alias_path} not found (incomplete modules tree?)")
    with open(alias_path, encoding="utf-8") as fh:
        for line in fh:
            if not line.startswith("alias of:"):
                continue
            parts = line.split()
            if len(parts) < 3:
                continue
            # The module name is the last field; intermediate fields
            # contain the patterns (including a suffixed "C*" variant).
            for token in parts[1:-1]:
                for compat in MODULE_ALIAS_OF_RE.findall(token):
                    alias_map[compat].add(parts[-1])
    return alias_map


def load_deps(modules_root: str) -> dict:
    deps = {}
    with open(os.path.join(modules_root, "modules.dep"), encoding="utf-8") as fh:
        for line in fh:
            if ":" not in line:
                continue
            module, rest = line.split(":", 1)
            deps[module.strip()] = rest.split()
    return deps


def main(argv) -> int:
    if len(argv) != 3:
        sys.stderr.write(__doc__)
        return 2
    kernel_out, modules_out = argv[1], argv[2]

    dtbs = glob(os.path.join(kernel_out, "dtbs", "**", "*.dtb"), recursive=True)
    if not dtbs:
        sys.exit(f"❌ no DTB in {kernel_out}/dtbs")
    dtb = dtbs[0]
    dts = subprocess.run(
        ["nix", "run", "nixpkgs#dtc", "--", "-I", "dtb", "-O", "dts", dtb],
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    compat = sorted(set(re.findall(r'compatible = "([^"]+)"', dts)))

    modules_root = glob(os.path.join(modules_out, "lib", "modules", "*"))[0]
    kernel_dir = os.path.join(modules_root, "kernel")
    by_path = {
        os.path.join(root, f).replace(f"{modules_root}/", ""): os.path.getsize(
            os.path.join(root, f)
        )
        for root, _, files in os.walk(kernel_dir)
        for f in files
        if f.endswith(".ko")
    }
    by_name = {module_name(p): p for p in by_path}

    alias_map = load_alias_map(modules_root)
    deps = load_deps(modules_root)

    matched = {
        by_name[name]
        for compat_key in compat
        for name in alias_map.get(compat_key, ())
        if name in by_name
    }

    def closure(mods):
        seen, stack = set(), list(mods)
        while stack:
            mod = stack.pop()
            if mod in seen or mod not in by_path:
                continue
            seen.add(mod)
            stack.extend(deps.get(mod, ()))
        return seen

    socle = {
        p for p in by_path if p[len("kernel/") :].startswith(SOCLE_PREFIXES)
    }
    keep_a = closure(matched)
    keep_b = keep_a | socle
    total = sum(by_path.values())

    print(f"DTB            : {dtb}")
    print(f"  {len(compat)} unique compatibles")
    print(f"Modules        : {len(by_path)} files, {total / 1e6:.1f} MB")
    print(f"Matched DTB    : {len(matched)} modules")
    for scenario, keep in (("A (DTB + closure)", keep_a), ("B (A + base)", keep_b)):
        size = sum(by_path[m] for m in keep)
        print(
            f"{scenario:22}: {len(keep):5}/{len(by_path)} modules, "
            f"{size / 1e6:6.1f} MB kept ({100 * size / total:.0f} %) — "
            f"{(total - size) / 1e6:.1f} MB removed"
        )

    pruned = by_path.keys() - keep_b
    by_cat = collections.Counter()
    for module in pruned:
        parts = module.split("/")
        by_cat["/".join(parts[1:3]) if len(parts) > 2 else "/".join(parts[1:])] += by_path[module]
    print(f"\nRemoved in B: {len(pruned)} modules, "
          f"{sum(by_path[m] for m in pruned) / 1e6:.1f} MB — top categories:")
    for cat, size in by_cat.most_common(12):
        print(f"   {size / 1e6:6.1f} MB  {cat}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
