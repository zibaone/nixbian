"""Unit tests for the guards scripts/check_drift.py and scripts/check_config.py.

The scripts are loaded by path (scripts/ is not a package); the
pure functions are tested without nix or access to metadata/.
"""

import importlib.util
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SCRIPTS_DIR = REPO_ROOT / "scripts"


def _load_script(name):
    spec = importlib.util.spec_from_file_location(
        f"nixbian_guard_{name}", SCRIPTS_DIR / f"{name}.py"
    )
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


check_drift = _load_script("check_drift")
check_config = _load_script("check_config")


# ---------------------------------------------------------------------------
# check_config.py
# ---------------------------------------------------------------------------


def test_parse_config_symbols_keeps_only_y_and_m():
    text = "\n".join(
        [
            "CONFIG_A=y",
            "CONFIG_B=m",
            "# CONFIG_C is not set",
            "CONFIG_INT=42",
            'CONFIG_STR="hello"',
            "# commentaire libre",
            "CONFIG_A=m",  # the last occurrence wins
        ]
    )
    assert check_config.parse_config_symbols(text) == {"CONFIG_A": "m", "CONFIG_B": "m"}


def test_compare_symbols_flags_missing_and_changed():
    reference = {"CONFIG_A": "y", "CONFIG_B": "m", "CONFIG_C": "y"}
    generated = {"CONFIG_A": "y", "CONFIG_B": "y"}
    assert check_config.compare_symbols(reference, generated) == [
        ("CONFIG_B", "m", "y"),
        ("CONFIG_C", "y", None),
    ]


def test_compare_symbols_ignores_extra_generated_symbols():
    # Extra symbols (platform defconfig) are not divergences.
    assert (
        check_config.compare_symbols(
            {"CONFIG_A": "y"}, {"CONFIG_A": "y", "CONFIG_X": "m"}
        )
        == []
    )


def test_find_family_config_prefers_linux_prefixed_name(tmp_path):
    configs = tmp_path / "nix" / "families" / "sunxi64" / "configs"
    configs.mkdir(parents=True)
    (configs / "linux-sunxi64-current.config").write_text("CONFIG_A=y\n")
    (configs / "linux-sunxi64-edge.config").write_text("CONFIG_A=y\n")
    found = check_config.find_family_config(tmp_path, "sunxi64", "current")
    assert found == configs / "linux-sunxi64-current.config"


def test_find_family_config_falls_back_to_unique_substring_match(tmp_path):
    # x86 case: the file is prefixed `linux-uefi-` → no exact match.
    configs = tmp_path / "nix" / "families" / "x86" / "configs"
    configs.mkdir(parents=True)
    (configs / "linux-uefi-x86-current.config").write_text("CONFIG_A=y\n")
    (configs / "linux-uefi-x86-edge.config").write_text("CONFIG_A=y\n")
    found = check_config.find_family_config(tmp_path, "x86", "current")
    assert found == configs / "linux-uefi-x86-current.config"


def test_find_family_config_uses_board_override(tmp_path):
    family_dir = tmp_path / "nix" / "families" / "generic"
    (family_dir / "configs").mkdir(parents=True)
    (family_dir / "boards").mkdir(parents=True)
    (family_dir / "configs" / "linux-xpressreal-t3-6.6.config").write_text(
        "CONFIG_A=y\n"
    )
    (family_dir / "boards" / "xpressreal-t3-vendor.nix").write_text(
        '{ platforms, lib }: lib.recursiveUpdate platforms."generic-vendor" '
        '{ kernel = { config_path_nix = "configs/linux-xpressreal-t3-6.6.config"; }; }\n'
    )
    found = check_config.find_family_config(
        tmp_path, "generic", "vendor", board_key="xpressreal-t3-vendor"
    )
    assert found == family_dir / "configs" / "linux-xpressreal-t3-6.6.config"


def test_find_family_config_returns_none_when_no_match(tmp_path):
    (tmp_path / "nix" / "families" / "x86" / "configs").mkdir(parents=True)
    assert check_config.find_family_config(tmp_path, "x86", "current") is None


def test_find_family_config_raises_on_ambiguity(tmp_path):
    configs = tmp_path / "nix" / "families" / "foo" / "configs"
    configs.mkdir(parents=True)
    (configs / "linux-foo-current-a.config").write_text("")
    (configs / "linux-foo-current-b.config").write_text("")
    with pytest.raises(check_config.ConfigGateError):
        check_config.find_family_config(tmp_path, "foo", "current")


class _FakeProc:
    def __init__(self, returncode, stdout="", stderr=""):
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr


def test_build_kernel_configfile_parses_nix_stdout(monkeypatch):
    calls = {}

    def fake_run(cmd, **kwargs):
        calls["cmd"] = cmd
        return _FakeProc(0, stdout="/nix/store/abc-linux-config/.config\n")

    monkeypatch.setattr(check_config.subprocess, "run", fake_run)
    result = check_config.build_kernel_configfile("board-x")
    assert result == Path("/nix/store/abc-linux-config/.config")
    assert calls["cmd"] == [
        "nix",
        "build",
        "--no-link",
        "--print-out-paths",
        ".#kernel-board-x.configfile",
    ]


def test_build_kernel_configfile_raises_on_nix_failure(monkeypatch):
    monkeypatch.setattr(
        check_config.subprocess,
        "run",
        lambda *a, **k: _FakeProc(1, stderr="error: boom"),
    )
    with pytest.raises(check_config.ConfigGateError, match="boom"):
        check_config.build_kernel_configfile("board-x")


# ---------------------------------------------------------------------------
# check_drift.py
# ---------------------------------------------------------------------------


def _write(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def test_compare_detects_modified_file(tmp_path):
    regen = tmp_path / "regen"
    ref = tmp_path / "ref"
    _write(regen / "library.nix", "line1\nnew\n")
    _write(ref / "library.nix", "line1\nold\n")
    problems = check_drift.compare(regen, ref)
    assert len(problems) == 1
    name, report = problems[0]
    assert name == "library.nix"
    assert "-old" in report and "+new" in report


def test_compare_clean_tree_has_no_problems(tmp_path):
    regen = tmp_path / "regen"
    ref = tmp_path / "ref"
    _write(regen / "library.nix", "same\n")
    _write(regen / "firmware.nix", "same\n")
    _write(ref / "library.nix", "same\n")
    _write(ref / "firmware.nix", "same\n")
    assert check_drift.compare(regen, ref) == []


def test_compare_flags_file_missing_from_metadata(tmp_path):
    regen = tmp_path / "regen"
    ref = tmp_path / "ref"
    ref.mkdir()
    _write(regen / "firmware.nix", "content\n")
    problems = check_drift.compare(regen, ref)
    assert len(problems) == 1
    name, report = problems[0]
    assert name == "firmware.nix"
    assert "absent" in report


def test_compare_errors_when_nothing_generated(tmp_path):
    regen = tmp_path / "regen"
    ref = tmp_path / "ref"
    regen.mkdir()
    ref.mkdir()
    with pytest.raises(check_drift.CheckError):
        check_drift.compare(regen, ref)
