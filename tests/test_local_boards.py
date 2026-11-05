"""Local board definitions: cards nixbian supports before Armbian does.

The local files use Armbian's board-conf format and are merged *after* Armbian's
own boards, so an upstream entry always wins. These tests pin the three
behaviours the generator relies on: discovery, synthetic targets, and the
"Armbian wins" rule.
"""

import json

import pytest

from armbian_extractor.core import NixbianExtractor


@pytest.fixture
def armbian_tree(tmp_path):
    """Minimal Armbian-like tree: one upstream board, one family conf."""
    src = tmp_path / "armbian"
    (src / "config" / "boards").mkdir(parents=True)
    (src / "config" / "boards" / "upstream-board.csc").write_text(
        'BOARD_NAME="Upstream"\nBOARDFAMILY="sun50iw9"\nKERNEL_TARGET="edge"\n'
    )
    return src


def make_extractor(tmp_path, armbian_tree, local_dir=None):
    return NixbianExtractor(
        armbian_tree,
        tmp_path / "out",
        local_boards_dir=local_dir,
    )


def test_local_board_conf_is_used_as_fallback(tmp_path, armbian_tree):
    local = tmp_path / "local"
    local.mkdir()
    (local / "transpeed-8k618-t.csc").write_text(
        'BOARDFAMILY="sun50iw9"\nKERNEL_TARGET="edge"\n'
    )
    extractor = make_extractor(tmp_path, armbian_tree, local)

    found = extractor._locate_board_conf("transpeed-8k618-t")
    assert found == local / "transpeed-8k618-t.csc"


def test_upstream_board_wins_over_local(tmp_path, armbian_tree, caplog):
    local = tmp_path / "local"
    local.mkdir()
    (local / "upstream-board.csc").write_text('BOARDFAMILY="wrong"\n')
    extractor = make_extractor(tmp_path, armbian_tree, local)

    found = extractor._locate_board_conf("upstream-board")
    assert found == armbian_tree / "config" / "boards" / "upstream-board.csc"
    assert "ignoring local" in caplog.text


def test_local_board_targets_expands_kernel_target(tmp_path, armbian_tree):
    local = tmp_path / "local"
    local.mkdir()
    (local / "box-a.csc").write_text('KERNEL_TARGET="current,edge"\n')
    (local / "box-b.conf").write_text('KERNEL_TARGET="edge,dev"\n')
    (local / "notes.txt").write_text("KERNEL_TARGET=edge\n")
    extractor = make_extractor(tmp_path, armbian_tree, local)

    # `dev` is never emitted (same filter as process_targets), .txt is not a board.
    assert extractor.local_board_targets() == [
        ("box-a", "current"),
        ("box-a", "edge"),
        ("box-b", "edge"),
    ]


def test_local_targets_are_appended_only_once(tmp_path, armbian_tree):
    local = tmp_path / "local"
    local.mkdir()
    (local / "transpeed-8k618-t.csc").write_text('KERNEL_TARGET="edge"\n')
    extractor = make_extractor(tmp_path, armbian_tree, local)

    targets = [
        {"vars": {"BOARD": "upstream-board", "BRANCH": "edge"}},
        {"vars": {"BOARD": "transpeed-8k618-t", "BRANCH": "edge"}},
    ]
    merged = extractor._append_local_targets(targets)
    assert merged is targets
    assert len([t for t in merged if t["vars"]["BOARD"] == "transpeed-8k618-t"]) == 1

    # A board Armbian already lists is not duplicated (it would be skipped by
    # `processed` anyway, but the target list must stay clean).
    only_upstream = [{"vars": {"BOARD": "transpeed-8k618-t", "BRANCH": "edge"}}]
    assert len(extractor._append_local_targets(only_upstream)) == 1


def test_process_targets_includes_local_board(tmp_path, armbian_tree, monkeypatch):
    local = tmp_path / "local"
    local.mkdir()
    (local / "transpeed-8k618-t.csc").write_text('KERNEL_TARGET="edge"\n')
    extractor = make_extractor(tmp_path, armbian_tree, local)

    targets_file = tmp_path / "targets.json"
    targets_file.write_text(
        json.dumps([{"vars": {"BOARD": "upstream-board", "BRANCH": "edge"}}])
    )

    seen = []

    def fake_extract(board_name, branch="current"):
        seen.append((board_name, branch))
        return {"board": board_name, "branch": branch, "linux_family": "sunxi64"}

    # Avoid the network for exact kernel versions.
    monkeypatch.setattr(extractor, "extract_board_config", fake_extract)
    monkeypatch.setattr(extractor, "enrich_exact_versions", lambda data: None)

    out = extractor.process_targets(targets_file)
    assert seen == [("upstream-board", "edge"), ("transpeed-8k618-t", "edge")]
    assert {entry["board"] for entry in json.loads(out.read_text())} == {
        "upstream-board",
        "transpeed-8k618-t",
    }


def test_missing_local_dir_is_not_an_error(tmp_path, armbian_tree):
    extractor = make_extractor(tmp_path, armbian_tree, tmp_path / "does-not-exist")
    assert extractor.local_board_targets() == []


def test_incremental_generation_leaves_platforms_and_package_untouched(tmp_path):
    """Incremental mode must not rewrite platform data from an older run.

    It writes only the new board file, the family index and boards.json; the
    existing boards and the two sentinel files stay byte-identical.
    """
    from armbian_extractor.generator import NixGenerator, NixLiteral

    out = tmp_path / "metadata"
    fam = out / "nix" / "families" / "sunxi64"
    (fam / "boards").mkdir(parents=True)
    (fam / "platforms.nix").write_text("# SENTINEL platforms\n")
    (fam / "package.nix").write_text("# SENTINEL package\n")
    (fam / "default.nix").write_text("# old index\n")
    (fam / "boards" / "oldtimer-edge.nix").write_text("# old board\n")

    def entry(board, dtb):
        return {
            "inherit": NixLiteral('platforms."sunxi64-edge"'),
            "board": board,
            "branch": "edge",
            "linux_family": "sunxi64",
            "arch": "arm64",
            "kernel": {
                "source": "https://example.com/linux.git",
                "branch": "branch:linux-7.0.y",
                "config_path": None,
            },
            "uboot": {
                "source": "https://example.com/uboot.git",
                "branch": "tag:v2025.04",
                "config": f"{board}_defconfig",
                "patch_dir": None,
            },
            "firmware": {},
            "dtb": dtb,
            "kernel_params": "console=ttyS0,115200",
            "firmware_include": None,
        }

    generator = NixGenerator(tmp_path / "armbian", out, armbian_version="v26.5.1")
    merged = [entry("oldtimer", "allwinner/old.dtb"), entry("box", "allwinner/box.dtb")]
    generator.generate(merged, prune=False, only_boards={"box-edge"})

    assert (fam / "platforms.nix").read_text() == "# SENTINEL platforms\n"
    assert (fam / "package.nix").read_text() == "# SENTINEL package\n"
    assert (fam / "boards" / "box-edge.nix").is_file()
    assert (fam / "boards" / "oldtimer-edge.nix").read_text() == "# old board\n"
    index = (fam / "default.nix").read_text()
    assert "oldtimer-edge" in index
    assert "box-edge" in index
    # No extra trailing blank line (full regeneration used to add one).
    assert index.endswith("}\n")
    # boards.json carries both boards.
    assert set(__import__("json").loads((out / "boards.json").read_text())) == {
        "oldtimer-edge",
        "box-edge",
    }
