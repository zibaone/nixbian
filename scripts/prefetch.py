#!/usr/bin/env python3
"""Parallel prefetch of the git sources pinned by `resolve_lock.py`.

Every changed branch needs its own `nix-prefetch-git` run, and a kernel
repository takes minutes to snapshot: thirty-five changed sources run one
after the other do not fit in a CI job. The sources are independent, so the
only thing to serialise is the output.

`prefetch_many` keeps the orchestration pure: the runner is injectable, which
is what the tests exercise (parallelism, partial failure, ordering).
"""

import json
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

DEFAULT_JOBS = 8
PER_SOURCE_TIMEOUT = 300


class PrefetchError(RuntimeError):
    """`nix-prefetch-git` could not produce a hash for one source."""


def prefetch_one(url: str, rev: str, timeout: int = PER_SOURCE_TIMEOUT) -> str:
    """Return the SRI sha256 of `url` at `rev`."""
    proc = subprocess.run(
        ["nix-prefetch-git", "--url", url, "--rev", rev],
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    if proc.returncode != 0:
        raise PrefetchError((proc.stderr or proc.stdout or "").strip()[:200])
    try:
        data = json.loads(proc.stdout)
    except json.JSONDecodeError as exc:
        raise PrefetchError(f"could not parse nix-prefetch-git output: {exc}") from exc
    sha256 = data.get("sha256", "")
    if not sha256:
        raise PrefetchError("nix-prefetch-git returned no sha256")
    return sha256


def prefetch_many(entries, jobs=DEFAULT_JOBS, runner=prefetch_one, log=print) -> dict:
    """Prefetch `entries` in parallel, returning {name: {rev, sha256}}.

    `entries` is a list of dicts with `name`, `url` and `rev`. A source that
    fails is reported and skipped: one unreachable repository must not drop
    the thirty-four others.
    """
    if not entries:
        return {}

    workers = max(1, min(int(jobs), len(entries)))
    log(f"📦 Prefetching {len(entries)} changed source(s) ({workers} at a time)...")

    results: dict[str, dict] = {}
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {
            pool.submit(runner, entry["url"], entry["rev"]): entry for entry in entries
        }
        for future in as_completed(futures):
            entry = futures[future]
            name = entry["name"]
            try:
                sha256 = future.result()
            except Exception as exc:  # noqa: BLE001 - one bad source, not a crash
                log(f"  ❌ {name}: {exc}")
                continue
            results[name] = {"rev": entry["rev"], "sha256": sha256}
            log(f"  ✅ {name}: {sha256}")

    return results
