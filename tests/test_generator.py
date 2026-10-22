import pytest
from armbian_extractor.generator import NixGenerator


def test_to_nix_basic_types():
    assert NixGenerator.to_nix(True) == "true"
    assert NixGenerator.to_nix(False) == "false"
    assert NixGenerator.to_nix(123) == "123"
    assert NixGenerator.to_nix(None) == "null"
    assert NixGenerator.to_nix("hello") == '"hello"'


def test_armbian_version_stamp_is_additive():
    from armbian_extractor.generator import NixGenerator

    entries = [{"board": "a"}, {"board": "b"}, "ignored"]
    assert NixGenerator.stamp_armbian_version(entries, "v26.5.1") == 3
    assert entries[0]["armbian_version"] == "v26.5.1"
    assert entries[1]["armbian_version"] == "v26.5.1"
    # Without a version: no mutation (metadata left untagged).
    untouched = [{"board": "a"}]
    assert NixGenerator.stamp_armbian_version(untouched, None) == 0
    assert "armbian_version" not in untouched[0]


def test_to_nix_escaping():
    # Escaping dollar sign for Nix interpolation
    assert NixGenerator.to_nix("value ${VAR}") == '"value \\${VAR}"'
    # Escaping quotes
    assert NixGenerator.to_nix('He said "Hello"') == '"He said \\"Hello\\""'


def test_to_nix_complex_structures():
    data = {"simple": "val", "nested-key": {"list": [1, 2, "three"], "bool": True}}
    # Keys are sorted: "nested-key" before "simple"
    expected = """{
  "nested-key" = {
    bool = true;
    list = [ 1 2 "three" ];
  };
  simple = "val";
}"""
    assert NixGenerator.to_nix(data) == expected


def test_to_nix_keys_sanitization():
    # Keys with dashes or starting with digits should be quoted
    data = {"123": "val", "with-dash": "val", "normal": "val"}
    output = NixGenerator.to_nix(data)
    assert '"123" = "val";' in output
    assert '"with-dash" = "val";' in output
    assert 'normal = "val";' in output


def _fake_patch_tree(root, files):
    """Create `patch/<component>/<rel>` with the requested files."""
    for rel, body in files.items():
        path = root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(body)
    return root


def test_collect_patches_recurses_and_follows_series(tmp_path):
    """Regression: a non-recursive glob saw no sunxi/filogic patch.

    Recent Armbian sets store everything in subdirectories and describe
    the order in series.conf; lines prefixed with `-` are disabled.
    """
    src = tmp_path / "armbian"
    root = src / "patch" / "kernel" / "archive" / "fam-7.0"
    _fake_patch_tree(
        root,
        {
            "patches.armbian/0100-a.patch": "a",
            "patches.armbian/0200-b.patch": "b",
            "patches.drm/0300-c.patch": "c",
            "patches.armbian/0400-unused.patch": "unused",
            "patches.megous/orphan.patch": "orphan",
        },
    )
    (root / "series.conf").write_text(
        "# ordre d'application\n"
        "patches.drm/0300-c.patch\n"
        "patches.armbian/0200-b.patch\n"
        "        patches.armbian/0100-a.patch\n"
        "-patches.armbian/0400-unused.patch\n"
    )

    gen = NixGenerator(src, tmp_path / "out")
    info = {"kernel": {"patch_dir": "archive/fam-7.0"}, "uboot": {"patch_dir": None}}
    gen._collect_patches(info, "kernel")

    prefix = "patches/kernel/archive/fam-7.0/"
    assert info["kernel"]["patches"] == [
        prefix + "patches.drm/0300-c.patch",
        prefix + "patches.armbian/0200-b.patch",
        prefix + "patches.armbian/0100-a.patch",
    ]
    # Tree structure preserved (two subdirectories can share the same name).
    copied = tmp_path / "out" / "nix" / prefix / "patches.armbian" / "0100-a.patch"
    assert copied.read_text() == "a"
    # Disabled upstream and not listed: never applied.
    assert not (
        tmp_path / "out" / "nix" / prefix / "patches.armbian" / "0400-unused.patch"
    ).exists()
    assert not (
        tmp_path / "out" / "nix" / prefix / "patches.megous" / "orphan.patch"
    ).exists()
    # uboot without patch_dir: nothing to do, no phantom key.
    assert "patches" not in info["uboot"]


def test_collect_patches_sorted_recursive_without_series(tmp_path):
    """Without series.conf: sorted recursive walk (and not zero patches)."""
    src = tmp_path / "armbian"
    root = src / "patch" / "kernel" / "archive" / "plain-7.0"
    _fake_patch_tree(
        root,
        {
            "b/0002-two.patch": "2",
            "a/0001-one.patch": "1",
            "0000-top.patch": "0",
        },
    )

    gen = NixGenerator(src, tmp_path / "out")
    info = {"kernel": {"patch_dir": "archive/plain-7.0"}, "uboot": {"patch_dir": None}}
    gen._collect_patches(info, "kernel")

    prefix = "patches/kernel/archive/plain-7.0/"
    assert info["kernel"]["patches"] == [
        prefix + "0000-top.patch",
        prefix + "a/0001-one.patch",
        prefix + "b/0002-two.patch",
    ]


def test_collect_patches_missing_dir_yields_empty_list(tmp_path):
    """Missing directory: explicit empty list (no phantom patch)."""
    src = tmp_path / "armbian"
    (src / "patch" / "kernel").mkdir(parents=True)
    gen = NixGenerator(src, tmp_path / "out")
    info = {"kernel": {"patch_dir": "archive/nope"}, "uboot": {"patch_dir": None}}
    gen._collect_patches(info, "kernel")
    assert info["kernel"]["patches"] == []
