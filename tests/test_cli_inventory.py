import json

from armbian_extractor.cli import run_legacy_compositor


def _script(path, body):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(body)
    path.chmod(0o755)


def test_uses_distinct_userspace_inventory(tmp_path):
    src = tmp_path / "armbian"
    out = tmp_path / "out"
    out.mkdir()
    info = src / "lib/tools/info"
    _script(
        info / "board-inventory.py",
        "import json, sys\njson.dump({'board': {}}, sys.stdout)\n",
    )
    _script(
        info / "userspace-inventory.py",
        "import json, sys\n"
        "json.dump([{'id': 'x', 'support': 'supported'}], sys.stdout)\n",
    )
    _script(
        info / "targets-compositor.py",
        "import json, sys\njson.dump({'argv': sys.argv[1:]}, sys.stdout)\n",
    )
    (src / "config/templates").mkdir(parents=True)
    (src / "config/templates/targets-default.yaml").write_text("")

    run_legacy_compositor(str(src), str(out))

    boards = json.loads((out / "all_boards_all_branches.json").read_text())
    userspace = json.loads((out / "all_userspace_inventory.json").read_text())
    targets = json.loads((out / "all-targets.json").read_text())

    assert boards == {"board": {}}
    assert userspace == [{"id": "x", "support": "supported"}]
    assert targets["argv"][0].endswith("all_boards_all_branches.json")
    assert targets["argv"][1].endswith("all_userspace_inventory.json")
