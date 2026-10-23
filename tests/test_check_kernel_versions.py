"""Tests for scripts/check_kernel_versions.py."""

import importlib.util
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "check_kernel_versions.py"
spec = importlib.util.spec_from_file_location("check_kernel_versions", SCRIPT)
ckv = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ckv)

PLATFORMS = '''
{
  "meson64-current" = {
    arch = "arm64";
    branch = "current";
    kernel = {
      branch = "branch:linux-6.18.y";
      config_path = "config/kernel/linux-meson64-current.config";
      exact_version = "6.18.58";
      nvfetcher_key = "kernel-meson64-branch-linux-6-18-y";
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    uboot = {
      config = "none";
    };
  };
  "sunxi-edge" = {
    arch = "arm64";
    kernel = {
      exact_version = "7.0.14";
      nvfetcher_key = "kernel-sunxi64-branch-linux-7-0-y";
      source = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
  };
  "bcm2711-current" = {
    arch = "arm64";
    kernel = {
      exact_version = "7.0.14";
      nvfetcher_key = "kernel-rpi";
      source = "https://github.com/raspberrypi/linux";
    };
  };
}
'''

MAKEFILE = """VERSION = 6
PATCHLEVEL = 18
SUBLEVEL = 38
EXTRAVERSION =
"""


class TestRawMakefileUrl:
    def test_kernel_org_keeps_the_git_suffix(self):
        url = ckv.raw_makefile_url(
            "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git", "abc123"
        )
        assert url == (
            "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
            "/plain/Makefile?id=abc123"
        )

    def test_github_drops_the_git_suffix(self):
        url = ckv.raw_makefile_url("https://github.com/raspberrypi/linux", "abc123")
        assert url == "https://raw.githubusercontent.com/raspberrypi/linux/abc123/Makefile"

    def test_github_with_git_suffix_is_normalised(self):
        url = ckv.raw_makefile_url("https://github.com/steev/linux.git", "abc")
        assert url == "https://raw.githubusercontent.com/steev/linux/abc/Makefile"

    def test_gitlab_uses_the_raw_path(self):
        url = ckv.raw_makefile_url(
            "https://gitlab.collabora.com/mediatek/aiot/linux.git", "abc"
        )
        assert url == "https://gitlab.collabora.com/mediatek/aiot/linux/-/raw/abc/Makefile"

    def test_unknown_host_returns_none(self):
        assert ckv.raw_makefile_url("https://example.org/foo", "abc") is None


class TestMakefileVersion:
    def test_reads_version_patchlevel_sublevel(self):
        assert ckv.makefile_version(MAKEFILE) == "6.18.38"

    def test_rejects_a_file_that_is_not_a_kernel_makefile(self):
        assert ckv.makefile_version("all:\n\techo hi\n") is None

    def test_ignores_extraversion(self):
        assert ckv.makefile_version("VERSION = 6\nPATCHLEVEL = 6\nSUBLEVEL = 12\n") == "6.6.12"


class TestParseKernelEntries:
    def test_finds_every_platform_block(self):
        entries = ckv.parse_kernel_entries(PLATFORMS)
        assert [e["key"] for e in entries] == [
            "meson64-current",
            "sunxi-edge",
            "bcm2711-current",
        ]

    def test_extracts_the_three_fields(self):
        entry = ckv.parse_kernel_entries(PLATFORMS)[0]
        assert entry["exact_version"] == "6.18.58"
        assert entry["nvfetcher_key"] == "kernel-meson64-branch-linux-6-18-y"
        assert entry["source"].endswith("linux.git")

    def test_does_not_mix_the_uboot_block_into_the_kernel(self):
        # `uboot` follows `kernel` and also has a `config`; a sloppy slice would
        # pick up its nvfetcher_key or source.
        entry = ckv.parse_kernel_entries(PLATFORMS)[0]
        assert entry["nvfetcher_key"].startswith("kernel-")


class TestAudit:
    def test_reports_a_mismatch(self):
        entries = ckv.parse_kernel_entries(PLATFORMS)
        lock = {"kernel-meson64-branch-linux-6-18-y": {"rev": "deadbeef"}}
        rows = ckv.audit(entries, lock, lambda _url: MAKEFILE)
        by_key = {r["key"]: r for r in rows}
        assert by_key["meson64-current"]["status"] == "mismatch"
        assert by_key["meson64-current"]["actual"] == "6.18.38"

    def test_matching_version_is_ok(self):
        entries = ckv.parse_kernel_entries(PLATFORMS)[1:]
        lock = {"kernel-sunxi64-branch-linux-7-0-y": {"rev": "cafe"}}
        rows = ckv.audit(entries, lock, lambda _url: "VERSION = 7\nPATCHLEVEL = 0\nSUBLEVEL = 14\n")
        assert {r["key"]: r["status"] for r in rows}["sunxi-edge"] == "ok"

    def test_missing_lock_entry_is_flagged_not_failed(self):
        entries = ckv.parse_kernel_entries(PLATFORMS)
        rows = ckv.audit(entries, {}, lambda _url: MAKEFILE)
        assert all(r["status"] == "no-lock-entry" for r in rows)

    def test_unreachable_source_is_reported_separately(self):
        entries = ckv.parse_kernel_entries(PLATFORMS)
        lock = {"kernel-meson64-branch-linux-6-18-y": {"rev": "deadbeef"}}
        rows = ckv.audit(entries, lock, lambda _url: None)
        assert {r["key"]: r["status"] for r in rows}["meson64-current"] == "fetch-failed"


class TestRealMetadata:
    """The committed metadata must be parseable by the gate."""

    def test_every_family_branch_has_a_kernel_source(self):
        metadata = Path(__file__).resolve().parents[1] / "metadata" / "nix" / "families"
        total = 0
        for platforms in metadata.glob("*/platforms.nix"):
            total += len(ckv.parse_kernel_entries(platforms.read_text()))
        assert total >= 50, f"only {total} kernel entries parsed, the block regex broke"
