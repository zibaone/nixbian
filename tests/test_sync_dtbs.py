"""Tests for scripts/sync_dtbs.py."""

import importlib.util
import json
import sys
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "sync_dtbs.py"
spec = importlib.util.spec_from_file_location("sync_dtbs", SCRIPT)
sync = importlib.util.module_from_spec(spec)
sys.path.insert(0, str(SCRIPT.parent))
spec.loader.exec_module(sync)

BOARD_NIX = """{ platforms, lib }:
lib.recursiveUpdate platforms."meson64-current" {
  board = "aml-a311d-cc";
  dtb = "amlogic/meson-g12b-libretech-cc.dtb";
  family = "meson64";
  uboot = {
    config = "none";
  };
}
"""


def test_reads_boot_fdt_file_only():
    data = {
        "a": {"BOARD_TOP_LEVEL_VARS": {"BOOT_FDT_FILE": "amlogic/a.dtb"}},
        "b": {"BOARD_TOP_LEVEL_VARS": {"BOARD_NAME": "no dtb"}},
        "c": {"BOARD_TOP_LEVEL_VARS": {}},
    }
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp) / "all_boards_all_branches.json"
        path.write_text(json.dumps(data))
        assert sync.armbian_dtbs(Path(tmp)) == {"a": "amlogic/a.dtb"}


def test_rewrites_the_dtb_line():
    out = sync.rewrite_board_nix(BOARD_NIX, "amlogic/meson-g12b-a311d-libretech-cc.dtb")
    assert 'dtb = "amlogic/meson-g12b-a311d-libretech-cc.dtb";' in out
    assert "meson-g12b-libretech-cc.dtb" not in out


def test_does_not_touch_anything_else():
    out = sync.rewrite_board_nix(BOARD_NIX, "amlogic/x.dtb")
    assert (
        out.replace("amlogic/x.dtb", "amlogic/meson-g12b-libretech-cc.dtb") == BOARD_NIX
    )


def test_missing_dtb_line_is_left_alone():
    text = '{ board = "x"; dtb = null; }\n'
    assert sync.rewrite_board_nix(text, "amlogic/x.dtb") == text
