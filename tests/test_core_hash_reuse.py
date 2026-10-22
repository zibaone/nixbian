"""Tests for hash preservation across regenerations without prefetch.

`core.get_nix_hash()` returns None when prefetch is disabled
(NIXBIAN_SKIP_PREFETCH=1, CI, network failure). Without reinjection from the
previous `board_metadata.json`, a regeneration rewrites `hash: null` for
all unpinned sources: already resolved hashes are lost and the
following builds break (fetch without hash).

These tests verify offline reinjection: no network access must take
place (the cache is consulted before the "skip prefetch" branch).
"""

import json
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from src.armbian_extractor import core

SRI = "sha256-8ruWxZbsb5I8EByJGaCvjgA8M43CRcjxFWt1Ci7a9Y4="
KERNEL_URL = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
UBOOT_URL = "https://github.com/u-boot/u-boot.git"
ATF_URL = "https://github.com/ARM-software/arm-trusted-firmware.git"


def _write_metadata(out_dir: Path) -> None:
    """Write a minimal board_metadata.json (1 board, 3 hashed sources)."""
    entries = [
        {
            "board": "testboard",
            "branch": "edge",
            "kernel": {
                "source": KERNEL_URL,
                "branch": "branch:linux-6.18.y",
                "major_minor": "6.18",
                "hash": SRI,
            },
            "uboot": {
                "source": UBOOT_URL,
                "branch": "tag:v2025.10",
                "source_hash": SRI,
                "atf_source": ATF_URL,
                "atf_branch": "branch:master",
                "atf_hash": SRI,
            },
        }
    ]
    (out_dir / "board_metadata.json").write_text(json.dumps(entries), encoding="utf-8")


@pytest.fixture(autouse=True)
def _preserve_generated_cache():
    """The global cache is mutated by the tests: it is restored afterwards."""
    saved = dict(core.GENERATED_CACHE)
    yield
    core.GENERATED_CACHE.clear()
    core.GENERATED_CACHE.update(saved)


def test_previous_hashes_are_reused(tmp_path, monkeypatch):
    """Kernel + uboot + ATF from the previous metadata feed GENERATED_CACHE."""
    monkeypatch.setenv("NIXBIAN_SKIP_PREFETCH", "1")
    _write_metadata(tmp_path)

    core.GENERATED_CACHE.clear()
    assert core.load_previous_metadata_cache(tmp_path) == 3

    # Cache consulted BEFORE the "skip prefetch" branch → no network request.
    assert core.get_nix_hash(KERNEL_URL, "linux-6.18.y") == SRI
    # The rev is normalized (refs/heads/, branch:, tag:… prefixes) as on write.
    assert core.get_nix_hash(KERNEL_URL, "refs/heads/linux-6.18.y") == SRI
    assert core.get_nix_hash(KERNEL_URL, "branch:linux-6.18.y") == SRI
    assert core.get_nix_hash(UBOOT_URL, "tag:v2025.10") == SRI
    assert core.get_nix_hash(ATF_URL, "master") == SRI


def test_placeholder_rev_is_resolved(tmp_path, monkeypatch):
    """Revs `${KERNEL_MAJOR_MINOR}` are resolved via the board's major_minor."""
    monkeypatch.setenv("NIXBIAN_SKIP_PREFETCH", "1")
    entries = [
        {
            "board": "testboard",
            "kernel": {
                "source": KERNEL_URL,
                "branch": "branch:linux-${KERNEL_MAJOR_MINOR}.y",
                "major_minor": "6.18",
                "hash": SRI,
            },
        }
    ]
    (tmp_path / "board_metadata.json").write_text(json.dumps(entries), encoding="utf-8")

    core.GENERATED_CACHE.clear()
    assert core.load_previous_metadata_cache(tmp_path) == 1
    assert core.get_nix_hash(KERNEL_URL, "linux-6.18.y") == SRI


def test_unknown_source_stays_none(tmp_path, monkeypatch):
    """A source missing from the previous metadata stays without hash (previous behavior)."""
    monkeypatch.setenv("NIXBIAN_SKIP_PREFETCH", "1")
    _write_metadata(tmp_path)
    core.GENERATED_CACHE.clear()
    core.load_previous_metadata_cache(tmp_path)
    assert core.get_nix_hash("https://example.invalid/repo", "linux-9.9.y") is None


def test_missing_metadata_file_is_not_fatal(tmp_path):
    """First run (no board_metadata.json): 0 hashes reused, no error."""
    assert core.load_previous_metadata_cache(tmp_path) == 0


def test_null_hashes_are_not_injected(tmp_path):
    """`hash: null` entries from the previous file do not pollute the cache."""
    entries = [
        {
            "board": "testboard",
            "kernel": {
                "source": KERNEL_URL,
                "branch": "branch:linux-7.0.y",
                "hash": None,
            },
        }
    ]
    (tmp_path / "board_metadata.json").write_text(json.dumps(entries), encoding="utf-8")
    core.GENERATED_CACHE.clear()
    assert core.load_previous_metadata_cache(tmp_path) == 0
