import json

from armbian_extractor.core import NixbianExtractor


class FakeCurl:
    returncode = 0

    def __init__(self, version):
        major, minor, patch = version.split(".")
        self.stdout = f"VERSION = {major}\nPATCHLEVEL = {minor}\nSUBLEVEL = {patch}\n"


def _extractor(out_dir, refresh=False):
    # The cache depends neither on the parser nor on the Armbian tree: we avoid a
    # full __init__ (which would read the source tree) to test the pure logic.
    ext = object.__new__(NixbianExtractor)
    ext.out_dir = out_dir
    ext.refresh_kernel_versions = refresh
    return ext


def _data(branch="branch:linux-6.18.y"):
    return [
        {
            "kernel": {
                "source": "https://git.kernel.org/linux.git",
                "branch": branch,
                "major_minor": "6.18",
            }
        }
    ]


def _key():
    return "https://git.kernel.org/linux.git|branch:linux-6.18.y"


def test_exact_version_cache_avoids_network(tmp_path, monkeypatch):
    (tmp_path / "kernel-versions.json").write_text(json.dumps({_key(): "6.18.58"}))
    calls = []
    monkeypatch.setattr(
        "armbian_extractor.core.subprocess.run", lambda *a, **k: calls.append(a)
    )

    data = _data()
    _extractor(tmp_path).enrich_exact_versions(data)

    assert data[0]["kernel"]["exact_version"] == "6.18.58"
    assert calls == []


def test_exact_version_refresh_fetches_and_updates_cache(tmp_path, monkeypatch):
    cache = tmp_path / "kernel-versions.json"
    cache.write_text(json.dumps({_key(): "6.18.58"}))
    monkeypatch.setattr(
        "armbian_extractor.core.subprocess.run",
        lambda *a, **k: FakeCurl("6.18.59"),
    )

    data = _data("branch:linux-${KERNEL_MAJOR_MINOR}.y")
    _extractor(tmp_path, refresh=True).enrich_exact_versions(data)

    assert data[0]["kernel"]["exact_version"] == "6.18.59"
    assert json.loads(cache.read_text())[_key()] == "6.18.59"


def test_exact_version_missing_cache_fetches_and_writes_cache(tmp_path, monkeypatch):
    calls = []

    def fake_run(*args, **kwargs):
        calls.append(args)
        return FakeCurl("6.18.58")

    monkeypatch.setattr("armbian_extractor.core.subprocess.run", fake_run)

    data = _data()
    _extractor(tmp_path).enrich_exact_versions(data)

    assert data[0]["kernel"]["exact_version"] == "6.18.58"
    assert len(calls) == 1
    assert json.loads((tmp_path / "kernel-versions.json").read_text()) == {
        _key(): "6.18.58"
    }
