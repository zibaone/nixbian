#!/usr/bin/env python3
"""Diff nvfetcher.sources.toml vs nvfetcher.lock.toml — show branches still floating."""
import tomllib
from pathlib import Path

src_path = Path("metadata/nvfetcher.sources.toml")
lock_path = Path("metadata/nvfetcher.lock.toml")

src = tomllib.loads(src_path.read_text())
lock = tomllib.loads(lock_path.read_text()) if lock_path.exists() else {}

for name in sorted(set(list(src.keys()) + list(lock.keys()))):
    s_rev = src.get(name, {}).get("rev", "N/A")
    l_rev = lock.get(name, {}).get("rev", "N/A")
    if s_rev != l_rev:
        print(f"  ⚡ {name}: {s_rev[:20]}... → {l_rev[:12]}...")
    elif s_rev.startswith("refs/heads/"):
        print(f"  🔓 {name}: {s_rev} (unlocked)")
    else:
        print(f"  🔒 {name}: {s_rev[:12]}... (locked)")
