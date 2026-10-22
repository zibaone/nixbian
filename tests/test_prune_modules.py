import os

from armbian_extractor.prune_modules import compute_keep, module_name


def touch(path, size=1024):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as fh:
        fh.write(b"\0" * size)


def test_module_name_normalises_dashes_and_compression():
    assert module_name("kernel/drivers/net/wireless/rtl8xxxu.ko") == "rtl8xxxu"
    assert module_name("kernel/drivers/foo/my-driver.ko") == "my_driver"
    assert module_name("kernel/drivers/foo/my-driver.ko.xz") == "my_driver"
    assert module_name("kernel/drivers/foo/README") == ""


def test_compute_keep_policy(tmp_path):
    root = tmp_path / "modules"
    paths = {
        "kernel/drivers/mmc/mmc_core.ko": 10,
        "kernel/drivers/net/ethernet/eth.ko": 10,
        "kernel/drivers/net/wireless/wl.ko": 10,
        "kernel/drivers/iio/adc/adc.ko": 10,
        "kernel/sound/usb/snd_usb.ko": 10,
        "kernel/drivers/gpu/gpu.ko": 10,
    }
    by_path = {}
    for rel, size in paths.items():
        touch(root / rel, size)
        by_path[rel] = size

    # snd_usb depends on adc: the closure must keep both.
    deps = {"kernel/sound/usb/snd_usb.ko": ["kernel/drivers/iio/adc/adc.ko"]}
    # DTB compatible → snd_usb.
    alias_map = {"vendor,board": {"snd_usb"}}
    # Explicit allowlist → wl (underscore in modules.alias).
    keep_path = tmp_path / "initrd-modules"
    touch(keep_path / "lib/modules/7.0.14/kernel/drivers/hwmon/hwmon.ko")

    keep, matched, requested, socle = compute_keep(
        by_path,
        deps,
        alias_map,
        ["vendor,board"],
        extra_keep=["wl"],
        keep_paths=[str(keep_path)],
    )

    assert "kernel/drivers/net/ethernet/eth.ko" in keep  # baseline
    assert "kernel/drivers/mmc/mmc_core.ko" in keep  # baseline
    assert "kernel/sound/usb/snd_usb.ko" in keep  # DTB compatible
    assert "kernel/drivers/iio/adc/adc.ko" in keep  # dependency (closure)
    assert "kernel/drivers/net/wireless/wl.ko" in keep  # allowlist
    assert "kernel/drivers/gpu/gpu.ko" not in keep  # deny-by-default
    assert matched == {"kernel/sound/usb/snd_usb.ko"}
    assert requested == {"kernel/drivers/net/wireless/wl.ko"}
    assert len(socle) == 2
