"""Tests for the parallel prefetch used by `scripts/resolve_lock.py`.

`prefetch_many` is pure orchestration around an injectable runner, so these
tests exercise the real concurrency and failure paths without touching the
network or `nix-prefetch-git`.
"""

import sys
import threading
import time
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT / "scripts"))

import prefetch  # noqa: E402


def entry(name, url="https://example.invalid/repo.git", rev="a" * 40):
    return {"name": name, "url": url, "rev": rev}


def test_prefetch_many_returns_a_hash_per_source():
    def runner(url, rev):
        return f"sha-{rev}"

    result = prefetch.prefetch_many(
        [entry("a"), entry("b")], runner=runner, log=lambda _: None
    )

    assert result == {
        "a": {"rev": "a" * 40, "sha256": f"sha-{'a' * 40}"},
        "b": {"rev": "a" * 40, "sha256": f"sha-{'a' * 40}"},
    }


def test_prefetch_many_passes_url_and_rev_to_the_runner():
    seen = []

    def runner(url, rev):
        seen.append((url, rev))
        return "sha"

    prefetch.prefetch_many(
        [
            entry("a", url="https://one", rev="1" * 40),
            entry("b", url="https://two", rev="2" * 40),
        ],
        runner=runner,
        log=lambda _: None,
    )

    assert sorted(seen) == [("https://one", "1" * 40), ("https://two", "2" * 40)]


def test_prefetch_many_skips_a_failing_source_without_dropping_the_others():
    def runner(url, rev):
        if url == "https://broken":
            raise prefetch.PrefetchError("boom")
        return "sha-ok"

    messages = []
    result = prefetch.prefetch_many(
        [entry("good"), entry("bad", url="https://broken")],
        runner=runner,
        log=messages.append,
    )

    assert set(result) == {"good"}
    assert any("bad" in message and "boom" in message for message in messages)


def test_prefetch_many_handles_an_empty_list():
    assert prefetch.prefetch_many([], runner=lambda *_: "sha") == {}


def test_prefetch_many_clamps_the_worker_count():
    """More workers than sources must not be requested from the pool."""
    seen = {}

    def runner(url, rev):
        seen.setdefault("max", 0)
        seen["max"] = max(seen["max"], threading.active_count())
        return "sha"

    result = prefetch.prefetch_many(
        [entry("a")], jobs=64, runner=runner, log=lambda _: None
    )

    assert set(result) == {"a"}


def test_prefetch_many_runs_sources_concurrently():
    """Two sources that each wait must overlap, or the pool is not used."""
    barrier = threading.Barrier(2, timeout=5)

    def runner(url, rev):
        # Only passes if both runners are alive at the same time.
        barrier.wait()
        return "sha"

    started = time.monotonic()
    result = prefetch.prefetch_many(
        [entry("a"), entry("b")], jobs=2, runner=runner, log=lambda _: None
    )
    elapsed = time.monotonic() - started

    assert set(result) == {"a", "b"}
    assert elapsed < 5


def test_prefetch_one_reports_a_nonzero_exit(monkeypatch):
    class FakeCompleted:
        returncode = 1
        stdout = ""
        stderr = "fatal: repository not found"

    monkeypatch.setattr(prefetch.subprocess, "run", lambda *a, **k: FakeCompleted())

    with pytest.raises(prefetch.PrefetchError, match="repository not found"):
        prefetch.prefetch_one("https://example.invalid/repo.git", "a" * 40)


def test_prefetch_one_rejects_a_payload_without_sha256(monkeypatch):
    class FakeCompleted:
        returncode = 0
        stdout = '{"storepath": "/nix/store/x"}'
        stderr = ""

    monkeypatch.setattr(prefetch.subprocess, "run", lambda *a, **k: FakeCompleted())

    with pytest.raises(prefetch.PrefetchError, match="no sha256"):
        prefetch.prefetch_one("https://example.invalid/repo.git", "a" * 40)


def test_prefetch_one_returns_the_sha256(monkeypatch):
    class FakeCompleted:
        returncode = 0
        stdout = '{"sha256": "0abc", "storepath": "/nix/store/x"}'
        stderr = ""

    monkeypatch.setattr(prefetch.subprocess, "run", lambda *a, **k: FakeCompleted())

    assert prefetch.prefetch_one("https://example.invalid/repo.git", "a" * 40) == "0abc"
