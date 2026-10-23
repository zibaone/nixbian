#!/usr/bin/env python3
"""Rewrite `exact_version` in the metadata so it matches the rev the lock pins.

The generator (`src/armbian_extractor/core.py`) reads the kernel version from the
*branch head*, while `nvfetcher.lock.toml` pins a specific `rev` — so the two
drift and `buildLinux` fails with `modDirVersion ... is wrong` after ~50 minutes
of compilation.

This is the missing step of the generation pipeline: run it **after**
`resolve_lock.py`, once the lock carries the revs that Nix will actually build.
It reads the `Makefile` at each pinned rev, rewrites the single `exact_version`
line of the affected family, and records the value in `kernel-versions.json`
under a `source|rev` key so a later regeneration can be offline and stable.

`metadata/` stays generated: nothing here is a hand edit, the input is the lock.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import re
import sys
import tomllib
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from check_kernel_versions import (  # noqa: E402
    audit,
    fetch_text,
    parse_kernel_entries,
    raw_makefile_url,
)


def rewrite_platform(
    text: str, entries: list[dict], updates: dict[str, str]
) -> tuple[str, list[str]]:
    """Replace `exact_version` inside each kernel block of `text`.

    Only the kernel table is touched, never `uboot` or `firmware`, which also
    carry a `config`/`version` of their own.
    """
    changed: list[str] = []
    pieces: list[str] = []
    cursor = 0
    for entry in entries:
        new_version = updates.get(entry["key"])
        if new_version is None:
            continue
        start, end = entry["block_start"], entry["block_end"]
        pieces.append(text[cursor:start])
        block = text[start:end]
        kernel_start = entry["kernel_start"] - start
        kernel_end = entry["kernel_end"] - start
        kernel = block[kernel_start:kernel_end]
        replaced, count = re.subn(
            r'(exact_version\s*=\s*")[^"]+(")',
            rf"\g<1>{new_version}\g<2>",
            kernel,
            count=1,
        )
        if count:
            changed.append(entry["key"])
            block = block[:kernel_start] + replaced + block[kernel_end:]
        pieces.append(block)
        cursor = end
    pieces.append(text[cursor:])
    return "".join(pieces), changed


def update_cache(cache_path: Path, rows: list[dict]) -> bool:
    """Record `source|rev -> version`, so the next run can resolve offline."""
    cache: dict[str, str] = {}
    if cache_path.exists():
        try:
            cache = json.loads(cache_path.read_text())
        except json.JSONDecodeError:
            cache = {}
    before = dict(cache)
    for row in rows:
        if row["status"] == "ok" or row["status"] == "mismatch":
            cache[f"{row['source']}|{row['rev']}"] = row["actual"]
    if cache == before:
        return False
    cache_path.write_text(json.dumps(dict(sorted(cache.items())), indent=2) + "\n")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--metadata-dir", type=Path, default=Path("metadata"))
    parser.add_argument("--jobs", type=int, default=6)
    parser.add_argument("--dry-run", action="store_true", help="report without writing")
    args = parser.parse_args()

    lock_path = args.metadata_dir / "nvfetcher.lock.toml"
    if not lock_path.exists():
        print(f"no lock at {lock_path}: nothing to synchronise", file=sys.stderr)
        return 1
    lock = tomllib.loads(lock_path.read_text())

    families = args.metadata_dir / "nix" / "families"
    parsed = {}
    for platforms in sorted(families.glob("*/platforms.nix")):
        parsed[platforms] = parse_kernel_entries(platforms.read_text())

    urls = set()
    for entries in parsed.values():
        for entry in entries:
            rev = (lock.get(entry["nvfetcher_key"] or "") or {}).get("rev")
            if rev and (url := raw_makefile_url(entry["source"], rev)):
                urls.add(url)

    texts: dict[str, str | None] = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for url, text in zip(urls, pool.map(fetch_text, urls)):
            texts[url] = text
    print(f"fetched {len(texts)} Makefiles")

    all_rows: list[dict] = []
    total_changed = 0
    for platforms, entries in parsed.items():
        rows = audit(entries, lock, lambda url: texts.get(url))
        all_rows.extend(rows)
        updates = {
            row["key"]: row["actual"] for row in rows if row["status"] == "mismatch"
        }
        if not updates:
            continue
        text = platforms.read_text()
        new_text, changed = rewrite_platform(text, entries, updates)
        if changed and not args.dry_run:
            platforms.write_text(new_text)
        total_changed += len(changed)
        for key in changed:
            row = next(r for r in rows if r["key"] == key)
            print(f"  {key:24} {row['declared']:10} -> {row['actual']}")

    if not args.dry_run and update_cache(
        args.metadata_dir / "kernel-versions.json", all_rows
    ):
        print("kernel-versions.json updated")

    counts: dict[str, int] = {}
    for row in all_rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print(f"{len(all_rows)} entries, {total_changed} rewritten, status: {counts}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
