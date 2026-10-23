"""Tests for scripts/sync_kernel_versions.py."""

import importlib.util
import json
import sys
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "sync_kernel_versions.py"
spec = importlib.util.spec_from_file_location("sync_kernel_versions", SCRIPT)
sync = importlib.util.module_from_spec(spec)
sys.path.insert(0, str(SCRIPT.parent))
spec.loader.exec_module(sync)

PLATFORMS = """{
  "meson64-current" = {
    arch = "arm64";
    kernel = {
      exact_version = "6.18.58";
      nvfetcher_key = "kernel-meson64";
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    uboot = {
      branch = "tag:v2024.07";
      exact_version = "2024.07";
      nvfetcher_key = "uboot-v2024-07";
      source = "https://github.com/u-boot/u-boot";
    };
  };
  "sunxi64-edge" = {
    arch = "arm64";
    kernel = {
      exact_version = "7.0.14";
      nvfetcher_key = "kernel-sunxi64";
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
  };
}
"""


def test_rewrites_the_kernel_block():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, changed = sync.rewrite_platform(
        PLATFORMS, entries, {"meson64-current": "6.18.38"}
    )
    assert changed == ["meson64-current"]
    assert 'exact_version = "6.18.38"' in text


def test_does_not_touch_the_uboot_block():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, _ = sync.rewrite_platform(PLATFORMS, entries, {"meson64-current": "6.18.38"})
    # The U-Boot table carries its own exact_version; it must stay untouched even
    # though the replacement is scoped to the same platform block.
    assert 'exact_version = "2024.07"' in text


def test_other_platforms_are_untouched():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, _ = sync.rewrite_platform(PLATFORMS, entries, {"meson64-current": "6.18.38"})
    assert text.count('exact_version = "7.0.14"') == 1


def test_only_one_line_per_block_is_replaced():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, changed = sync.rewrite_platform(
        PLATFORMS, entries, {"meson64-current": "6.18.38"}
    )
    assert changed == ["meson64-current"]
    assert "6.18.58" not in text


def test_no_update_is_a_noop():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, changed = sync.rewrite_platform(PLATFORMS, entries, {})
    assert changed == []
    assert text == PLATFORMS


def test_two_blocks_can_be_rewritten_at_once():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, changed = sync.rewrite_platform(
        PLATFORMS, entries, {"meson64-current": "6.18.38", "sunxi64-edge": "7.0.15"}
    )
    assert changed == ["meson64-current", "sunxi64-edge"]
    assert 'exact_version = "6.18.38"' in text and 'exact_version = "7.0.15"' in text


def test_output_is_still_parseable():
    entries = sync.parse_kernel_entries(PLATFORMS)
    text, _ = sync.rewrite_platform(PLATFORMS, entries, {"meson64-current": "6.18.38"})
    again = {e["key"]: e["exact_version"] for e in sync.parse_kernel_entries(text)}
    assert again["meson64-current"] == "6.18.38"
    assert again["sunxi64-edge"] == "7.0.14"


def test_cache_is_keyed_by_rev_and_is_idempotent(tmp_path):
    cache_path = tmp_path / "kernel-versions.json"
    rows = [
        {
            "status": "mismatch",
            "source": "https://x/linux.git",
            "rev": "abc",
            "actual": "6.18.38",
        },
        {
            "status": "fetch-failed",
            "source": "https://x/linux.git",
            "rev": "def",
            "actual": None,
        },
    ]
    assert sync.update_cache(cache_path, rows) is True
    assert json.loads(cache_path.read_text()) == {"https://x/linux.git|abc": "6.18.38"}
    # Second call changes nothing, so the file is not rewritten.
    assert sync.update_cache(cache_path, rows) is False
