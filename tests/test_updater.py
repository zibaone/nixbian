import pytest
from armbian_extractor.updater import NixbianUpdater


def test_sort_tags():
    tags = [
        "v2017.07",
        "v25.11.1",
        "v2021.05",
        "v25.2.1",
    ]
    # Expectation: v25.11.1 > v25.2.1 > v2021.05 > v2017.07
    sorted_tags = NixbianUpdater.sort_tags(tags)
    assert sorted_tags == ["v25.11.1", "v25.2.1", "v2021.05", "v2017.07"]


def test_sort_tags_micro_versions():
    tags = ["v25.8.1", "v25.8.10", "v25.8.2"]
    sorted_tags = NixbianUpdater.sort_tags(tags)
    assert sorted_tags == ["v25.8.10", "v25.8.2", "v25.8.1"]
