"""Tests for the family configuration fragments exposed by the generator.

Spec nixbian-kernel-config-v2 §3: FAMILY_CONFIG_FLAGS (values
"-e CONFIG_X -e CONFIG_Y", incompatible with merge_config.sh which does not
accept -e) is replaced by FAMILY_CONFIG_FRAGMENTS (multi-line values
"CONFIG_X=y"). Frozen name: implemented in src/armbian_extractor/generator.py.
"""

import re
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

# Import of the frozen name — failure is reported explicitly in each test.
try:
    from src.armbian_extractor.generator import FAMILY_CONFIG_FRAGMENTS

    IMPORT_ERROR = None
except Exception as exc:  # ImportError, SyntaxError if generator.py is being edited…
    FAMILY_CONFIG_FRAGMENTS = None
    IMPORT_ERROR = exc

# Valid fragment line: strictly CONFIG_FOO=y or CONFIG_FOO=m.
FRAGMENT_LINE_RE = re.compile(r"^CONFIG_[A-Z0-9_]+=[ym]$")

# Families whose key must survive the mechanical conversion (spec §3).
EXPECTED_FAMILY_KEYS = {"arm64", "generic", "loong64", "x86", "sunxi64", "rockchip64"}


def _fragments():
    """Return FAMILY_CONFIG_FRAGMENTS, or fail with an explicit message."""
    if IMPORT_ERROR is not None:
        pytest.fail(
            "Échec de l'import « from src.armbian_extractor.generator import "
            f"FAMILY_CONFIG_FRAGMENTS » : {IMPORT_ERROR!r}. "
            "generator.py doit exposer FAMILY_CONFIG_FRAGMENTS "
            "(dict famille -> fragment multi-lignes « CONFIG_X=y »)."
        )
    return FAMILY_CONFIG_FRAGMENTS


def test_family_config_fragments_importable():
    """The frozen name FAMILY_CONFIG_FRAGMENTS exists and is non-null."""
    assert _fragments() is not None


def test_fragments_mapping_shape():
    """Minimal shape: non-empty dict, values of type str."""
    fragments = _fragments()
    assert isinstance(fragments, dict), "FAMILY_CONFIG_FRAGMENTS must be a dict"
    assert fragments, "FAMILY_CONFIG_FRAGMENTS must not be empty"
    for family, value in fragments.items():
        assert isinstance(family, str) and family, f"invalid family key: {family!r}"
        assert isinstance(value, str), (
            f"fragment for {family!r}: expected a string, got {type(value).__name__}"
        )


def test_well_known_families_present():
    """The key families (including sunxi64/rockchip64) are present."""
    missing = sorted(EXPECTED_FAMILY_KEYS - set(_fragments()))
    assert not missing, f"familles absentes de FAMILY_CONFIG_FRAGMENTS : {missing}"


def test_every_nonempty_line_is_a_config_symbol():
    """Every non-empty line matches ^CONFIG_[A-Z0-9_]+=[ym]$."""
    invalid = []
    for family, value in _fragments().items():
        for line in value.splitlines():
            stripped = line.strip()
            if stripped and not FRAGMENT_LINE_RE.match(stripped):
                invalid.append(f"{family}: {stripped!r}")
    assert not invalid, (
        "Invalid fragment lines (expected ^CONFIG_[A-Z0-9_]+=[ym]$):\n"
        + "\n".join(invalid)
    )


def test_no_dash_e_flag_values_left():
    """No value or line starting with "-e" remains (old merge_config.sh flags)."""
    invalid = []
    for family, value in _fragments().items():
        if value.strip().startswith("-e "):
            invalid.append(f"{family}: la valeur commence par '-e '")
        for line in value.splitlines():
            if line.strip().startswith("-e "):
                invalid.append(f"{family}: ligne {line.strip()!r}")
    assert not invalid, (
        "Reste des flags « -e … » dans FAMILY_CONFIG_FRAGMENTS "
        "(merge_config.sh n'accepte pas -e) :\n" + "\n".join(invalid)
    )
