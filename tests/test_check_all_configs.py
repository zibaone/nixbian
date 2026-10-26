"""Tests for the family-wide configuration gate (`scripts/check_all_configs.py`).

The gate has two halves: a `nix eval` that we cannot run in unit tests, and
a pure comparison (`audit`) plus a `platforms.nix` parser that we can and
must cover. These tests exercise the parser against a synthetic family tree
and the comparison against in-memory wiring, so a regression in either half
fails here before it reaches CI.
"""

import json
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT / "scripts"))

import check_all_configs as gate  # noqa: E402


def write_platforms(family_dir: Path, blocks: dict[str, str]) -> None:
    """Write a minimal `platforms.nix` mirroring the generator's layout."""
    family_dir.mkdir(parents=True, exist_ok=True)
    lines = ["{"]
    for name, config in blocks.items():
        lines += [
            f'  "{name}" = {{',
            '    arch = "arm64";',
            '    branch = "edge";',
            "    kernel = {",
            f'      config = "linux-{name}";',
            f'      config_path_nix = "{config}";',
            "    };",
            "  };",
        ]
    lines.append("}")
    (family_dir / "platforms.nix").write_text("\n".join(lines) + "\n")


def make_metadata(tmp_path: Path, families: dict[str, dict[str, str]]) -> Path:
    """Build a metadata tree: families -> {platform name: config's content}."""
    metadata = tmp_path / "metadata"
    for family, blocks in families.items():
        family_dir = metadata / "nix" / "families" / family
        configs = {
            name: f"CONFIG_{name.upper().replace('-', '_')}=y\n" for name in blocks
        }
        write_platforms(
            family_dir, {name: f"configs/linux-{name}.config" for name in blocks}
        )
        (family_dir / "configs").mkdir(parents=True, exist_ok=True)
        for name, content in configs.items():
            (family_dir / "configs" / f"linux-{name}.config").write_text(content)
    return metadata


# ---------------------------------------------------------------- the parser


def test_collect_reference_configs_maps_each_platform_to_its_config(tmp_path):
    metadata = make_metadata(
        tmp_path,
        {
            "sunxi64": {"sunxi64-edge": None, "sunxi64-current": None},
            "arm64": {"arm64-cloud": None},
        },
    )

    refs = gate.collect_reference_configs(metadata)

    assert set(refs) == {"sunxi64-edge", "sunxi64-current", "arm64-cloud"}
    assert refs["sunxi64-edge"]["path"] == (
        metadata
        / "nix"
        / "families"
        / "sunxi64"
        / "configs"
        / "linux-sunxi64-edge.config"
    )
    # The family directory must be preserved: a config named after another
    # family (arm64-cloud lives under `arm64/`) must not be looked up under
    # the wrong family.
    assert refs["arm64-cloud"]["path"].parent.parent.name == "arm64"


def test_collect_reference_configs_ignores_families_without_platforms(tmp_path):
    metadata = make_metadata(tmp_path, {"sunxi64": {"sunxi64-edge": None}})
    (metadata / "nix" / "families" / "empty").mkdir()

    refs = gate.collect_reference_configs(metadata)

    assert set(refs) == {"sunxi64-edge"}


def test_collect_reference_configs_fails_without_metadata(tmp_path):
    with pytest.raises(gate.GateError, match="metadata missing"):
        gate.collect_reference_configs(tmp_path / "nowhere")


def test_collect_reference_configs_matches_the_real_tree():
    """Guard against drift between this parser and the generated metadata."""
    refs = gate.collect_reference_configs(REPO_ROOT / "metadata")

    boards = json.loads((REPO_ROOT / "metadata" / "boards.json").read_text())
    pairs = {f"{b['family']}-{b['branch']}" for b in boards.values()}

    # Four pairs carry no `config_path_nix`: the three `generic`/`arm64`
    # variants that the generator wires without an Armbian config, plus
    # `generic-edge`, whose upstream config file does not exist at all.
    unmapped = {"arm64-sc8280xp", "generic-current", "generic-vendor", "generic-edge"}
    assert pairs - set(refs) == unmapped
    assert len(pairs) == 57
    assert len(refs) == 53


# ------------------------------------------------------------ the comparison


def board(family: str, branch: str) -> dict:
    return {"family": family, "branch": branch}


def test_audit_accepts_an_identical_config(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")
    applied = tmp_path / "applied"
    applied.write_text("CONFIG_A=y\n")

    result = gate.audit(
        {"b-edge": board("fam", "edge")},
        {"kernel-b-edge": {"mode": "armbian", "cfg": str(applied)}},
        {"fam-edge": ref},
    )

    assert result["problems"] == []
    assert result["warnings"] == []
    assert result["verified"] == {"fam-edge": str(ref)}
    assert result["boards_verified"] == 1


def test_audit_flags_a_content_divergence(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")
    applied = tmp_path / "applied"
    applied.write_text("CONFIG_A=y\nCONFIG_B=y\n")

    result = gate.audit(
        {"b-edge": board("fam", "edge")},
        {"kernel-b-edge": {"mode": "armbian", "cfg": str(applied)}},
        {"fam-edge": ref},
    )

    assert len(result["problems"]) == 1
    assert "differs from the reference" in result["problems"][0]
    assert "1 board(s) affected" in result["problems"][0]


def test_audit_reports_a_divergence_once_per_pair_not_per_board(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")
    applied = tmp_path / "applied"
    applied.write_text("CONFIG_OTHER=y\n")

    boards = {f"b{i}-edge": board("fam", "edge") for i in range(40)}
    wiring = {
        f"kernel-b{i}-edge": {"mode": "armbian", "cfg": str(applied)} for i in range(40)
    }

    result = gate.audit(boards, wiring, {"fam-edge": ref})

    assert len(result["problems"]) == 1
    assert "40 board(s) affected" in result["problems"][0]


def test_audit_skips_defconfig_and_nixpkgs_tiers(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")

    result = gate.audit(
        {
            "def-edge": board("fam", "edge"),
            "nix-current": board("fam", "current"),
        },
        {
            "kernel-def-edge": {"mode": "defconfig", "cfg": None},
            "kernel-nix-current": {"mode": "nixpkgs", "cfg": None},
        },
        {"fam-edge": ref},
    )

    assert result["problems"] == []
    assert result["verified"] == {}
    assert result["tiers"] == {"defconfig": 1, "nixpkgs": 1}


def test_audit_warns_instead_of_failing_when_a_pair_has_no_kernel(tmp_path):
    result = gate.audit(
        {"b-edge": board("generic", "edge")},
        {},  # no kernel attribute at all
        {},
    )

    assert result["problems"] == []
    assert len(result["warnings"]) == 1
    assert "no `kernel-b-edge` attribute" in result["warnings"][0]


def test_audit_flags_a_missing_reference_config(tmp_path):
    applied = tmp_path / "applied"
    applied.write_text("CONFIG_A=y\n")

    result = gate.audit(
        {"b-edge": board("fam", "edge")},
        {"kernel-b-edge": {"mode": "armbian", "cfg": str(applied)}},
        {},  # platforms.nix had no config_path_nix for this pair
    )

    assert len(result["problems"]) == 1
    assert "no reference config in platforms.nix" in result["problems"][0]


def test_audit_flags_an_armbian_pair_without_configfile(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")

    result = gate.audit(
        {"b-edge": board("fam", "edge")},
        {"kernel-b-edge": {"mode": "armbian", "cfg": None}},
        {"fam-edge": ref},
    )

    assert len(result["problems"]) == 1
    assert "no configfile exposed" in result["problems"][0]


def test_audit_flags_a_missing_applied_file(tmp_path):
    ref = tmp_path / "cfg"
    ref.write_text("CONFIG_A=y\n")

    result = gate.audit(
        {"b-edge": board("fam", "edge")},
        {"kernel-b-edge": {"mode": "armbian", "cfg": str(tmp_path / "gone")}},
        {"fam-edge": ref},
    )

    assert len(result["problems"]) == 1
    assert "applied config not found" in result["problems"][0]


# --------------------------------------------------------------- the exit code


def test_main_returns_2_when_boards_json_is_missing(tmp_path):
    metadata = tmp_path / "metadata"
    (metadata / "nix" / "families").mkdir(parents=True)

    assert gate.main(["--metadata-dir", str(metadata)]) == 2


def test_main_returns_1_on_a_divergence(tmp_path, monkeypatch, capsys):
    metadata = make_metadata(tmp_path, {"fam": {"fam-edge": None}})
    (metadata / "boards.json").write_text(json.dumps({"b-edge": board("fam", "edge")}))

    # Pretend the flake applies a different config than the reference.
    stray = tmp_path / "stray.config"
    stray.write_text("CONFIG_SOMETHING_ELSE=y\n")
    monkeypatch.setattr(
        gate,
        "eval_kernel_wiring",
        lambda system: {"kernel-b-edge": {"mode": "armbian", "cfg": str(stray)}},
    )

    assert gate.main(["--metadata-dir", str(metadata)]) == 1
    assert "differs from the reference" in capsys.readouterr().err


def test_main_returns_0_when_everything_matches(tmp_path, monkeypatch, capsys):
    metadata = make_metadata(tmp_path, {"fam": {"fam-edge": None}})
    (metadata / "boards.json").write_text(json.dumps({"b-edge": board("fam", "edge")}))
    reference = (
        metadata / "nix" / "families" / "fam" / "configs" / "linux-fam-edge.config"
    )

    monkeypatch.setattr(
        gate,
        "eval_kernel_wiring",
        lambda system: {"kernel-b-edge": {"mode": "armbian", "cfg": str(reference)}},
    )

    assert gate.main(["--metadata-dir", str(metadata)]) == 0
    assert "1 family/branch pair(s) verified" in capsys.readouterr().out
