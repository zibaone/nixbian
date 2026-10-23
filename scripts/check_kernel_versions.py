#!/usr/bin/env python3
"""Check that `exact_version` in the metadata matches the kernel source Nix builds.

`metadata/nix/families/*/platforms.nix` carries `kernel.exact_version`, which
becomes `modDirVersion` in `library.nix`. When it disagrees with the `Makefile`
of the pinned source, the build dies after ~50 minutes with:

    Error: modDirVersion 6.18.58 specified in the Nix expression is wrong,
    it should be: 6.18.38

The generator derives that value from the *branch head* (`core.py:617`), while
`nvfetcher.lock.toml` pins a specific `rev` — so the two drift apart and nothing
catches it until a kernel is actually compiled. This script compares the declared
value with the `Makefile` at the locked rev: one small HTTP request per
family+branch, a few seconds in total.

Exit code 1 on any mismatch.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import re
import subprocess
import sys
import tomllib
from pathlib import Path

PLATFORM_RE = re.compile(r'^\s*"([a-z0-9_.-]+)"\s*=\s*\{', re.M)
KERNEL_BLOCK_RE = re.compile(r"\n\s*kernel\s*=\s*\{")
VERSION_RE = {
    name: re.compile(rf"^{name}\s*=\s*([0-9]+)", re.M)
    for name in ("VERSION", "PATCHLEVEL", "SUBLEVEL")
}


def raw_makefile_url(source: str, rev: str) -> str | None:
    """Best-effort raw URL for the `Makefile` at `rev` in `source`."""
    url = source.rstrip("/")
    if "github.com" in url:
        # raw.githubusercontent wants the repo name without the `.git` suffix.
        parts = url.split("github.com/", 1)[1].split("/")
        if len(parts) < 2:
            return None
        repo = parts[1][:-4] if parts[1].endswith(".git") else parts[1]
        return f"https://raw.githubusercontent.com/{parts[0]}/{repo}/{rev}/Makefile"
    if "git.kernel.org" in url:
        # cgit needs the `.git` in the path: .../linux.git/plain/Makefile
        path = url.split("git.kernel.org/", 1)[1]
        return f"https://git.kernel.org/{path}/plain/Makefile?id={rev}"
    if "gitlab" in url:
        repo = url[:-4] if url.endswith(".git") else url
        return f"https://{repo.split('://', 1)[1]}/-/raw/{rev}/Makefile"
    return None


def makefile_version(text: str) -> str | None:
    """`VERSION.PATCHLEVEL.SUBLEVEL`, or None when this is not a kernel Makefile."""
    parts = []
    for regex in VERSION_RE.values():
        match = regex.search(text)
        if not match:
            return None
        parts.append(match.group(1))
    return ".".join(parts)


def _field(text: str, name: str) -> str | None:
    match = re.search(rf'{name}\s*=\s*"([^"]+)"', text)
    return match.group(1) if match else None


def parse_kernel_entries(platforms_nix: str) -> list[dict]:
    """Every `<family>-<branch>` block that carries a kernel with a source."""
    entries: list[dict] = []
    starts = [(m.start(), m.group(1)) for m in PLATFORM_RE.finditer(platforms_nix)]
    for index, (start, key) in enumerate(starts):
        end = starts[index + 1][0] if index + 1 < len(starts) else len(platforms_nix)
        block = platforms_nix[start:end]
        marker = KERNEL_BLOCK_RE.search(block)
        if not marker:
            continue
        rest = block[marker.end() :]
        closing = re.search(r"\n\s{4}\};", rest)
        kernel = rest[: closing.start()] if closing else rest
        source = _field(kernel, "source")
        if not source:
            continue
        entries.append(
            {
                "key": key,
                "source": source,
                "nvfetcher_key": _field(kernel, "nvfetcher_key"),
                "exact_version": _field(kernel, "exact_version"),
            }
        )
    return entries


def audit(entries: list[dict], lock: dict, fetch) -> list[dict]:
    """Compare each declared `exact_version` with the source at the locked rev."""
    results = []
    for entry in entries:
        rev = (lock.get(entry["nvfetcher_key"] or "") or {}).get("rev")
        row = {
            "key": entry["key"],
            "declared": entry["exact_version"],
            "rev": rev,
            "actual": None,
            "status": "ok",
        }
        if not rev:
            row["status"] = "no-lock-entry"
        else:
            url = raw_makefile_url(entry["source"], rev)
            if url is None:
                row["status"] = "unsupported-source"
            else:
                actual = makefile_version(fetch(url) or "")
                row["actual"] = actual
                if actual is None:
                    row["status"] = "fetch-failed"
                elif actual != row["declared"]:
                    row["status"] = "mismatch"
        results.append(row)
    return results


def fetch_text(url: str) -> str | None:
    try:
        result = subprocess.run(
            ["curl", "-sL", "-A", "nixbian-ci", "--connect-timeout", "10", url],
            capture_output=True,
            text=True,
            timeout=30,
        )
        return result.stdout if result.returncode == 0 and result.stdout else None
    except Exception:
        return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--metadata-dir", type=Path, default=Path("metadata"))
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument(
        "--skip-network",
        action="store_true",
        help="do not fetch anything; report only what cannot be verified",
    )
    args = parser.parse_args()

    lock_path = args.metadata_dir / "nvfetcher.lock.toml"
    lock = tomllib.loads(lock_path.read_text()) if lock_path.exists() else {}

    entries: list[dict] = []
    for platforms in sorted((args.metadata_dir / "nix" / "families").glob("*/platforms.nix")):
        entries.extend(parse_kernel_entries(platforms.read_text()))

    texts: dict[str, str | None] = {}
    if not args.skip_network:
        urls = {
            url
            for entry in entries
            if (rev := (lock.get(entry["nvfetcher_key"] or "") or {}).get("rev"))
            if (url := raw_makefile_url(entry["source"], rev))
        }
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
            for url, text in zip(urls, pool.map(fetch_text, urls)):
                texts[url] = text
        print(f"fetched {len(texts)} Makefiles")

    results = audit(entries, lock, lambda url: texts.get(url))

    counts: dict[str, int] = {}
    for row in results:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print(f"{len(results)} kernel entries checked")
    for status, number in sorted(counts.items()):
        print(f"  {status}: {number}")

    bad = [row for row in results if row["status"] == "mismatch"]
    if bad:
        print("\nmodDirVersion mismatch — these builds would fail:")
        for row in sorted(bad, key=lambda r: r["key"]):
            print(f"  {row['key']:24} declared {row['declared']:10} source at {row['rev'][:8]} is {row['actual']}")
        print(
            "\nexact_version is derived from the branch head, the build uses the locked rev."
            "\nRegenerate the versions against the lock, not the branch."
        )
        return 1

    unverified = [row for row in results if row["status"] in {"fetch-failed", "no-lock-entry", "unsupported-source"}]
    if unverified:
        print(f"\n{len(unverified)} entries could not be verified:")
        for row in unverified[:10]:
            print(f"  {row['key']}: {row['status']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
