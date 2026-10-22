from pathlib import Path

from armbian_extractor.core import relativize_path
from armbian_extractor.generator import NixGenerator, sanitize_patch_name


def test_relativize_path_strips_source_prefix():
    src = Path("/nix/store/abc-source")
    value = f"{src}/config/kernel/linux-sunxi64-edge.config"
    assert relativize_path(value, src) == "config/kernel/linux-sunxi64-edge.config"


def test_relativize_path_strips_prefix_in_middle():
    src = Path("/nix/store/abc-source")
    value = (
        f"BL32={src}/cache/sources/rkbin/rk3308_bl31.elf "
        f"ROCKCHIP_TPL={src}/cache/sources/rkbin/rk3308_ddr.bin"
        ";;u-boot-rockchip.bin"
    )
    assert relativize_path(value, src) == (
        "BL32=cache/sources/rkbin/rk3308_bl31.elf "
        "ROCKCHIP_TPL=cache/sources/rkbin/rk3308_ddr.bin"
        ";;u-boot-rockchip.bin"
    )


def test_relativize_path_leaves_relative_and_empty_values():
    src = Path("/nix/store/abc-source")
    assert relativize_path("cache/sources/rkbin", src) == "cache/sources/rkbin"
    assert relativize_path(None, src) is None
    assert relativize_path("", src) == ""
    assert relativize_path(42, src) == 42


def test_collect_kernel_config_resolves_relative_path(tmp_path):
    src = tmp_path / "armbian"
    config = src / "config" / "kernel" / "linux-test.config"
    config.parent.mkdir(parents=True)
    config.write_text("CONFIG_X=y\n")

    gen = NixGenerator(src, tmp_path / "out")
    board = {
        "linux_family": "sunxi64",
        "kernel": {"config_path": "config/kernel/linux-test.config"},
    }
    gen._collect_kernel_config(board)

    assert board["kernel"]["config_path_nix"] == "configs/linux-test.config"
    copied = tmp_path / "out/nix/families/sunxi64/configs/linux-test.config"
    assert copied.read_text() == "CONFIG_X=y\n"


def test_collect_kernel_config_accepts_absolute_path(tmp_path):
    src = tmp_path / "armbian"
    config = tmp_path / "elsewhere" / "linux-test.config"
    config.parent.mkdir(parents=True)
    config.write_text("CONFIG_Y=y\n")

    gen = NixGenerator(src, tmp_path / "out")
    board = {"linux_family": "sunxi64", "kernel": {"config_path": str(config)}}
    gen._collect_kernel_config(board)

    assert board["kernel"]["config_path_nix"] == "configs/linux-test.config"
    assert (
        tmp_path / "out/nix/families/sunxi64/configs/linux-test.config"
    ).read_text() == "CONFIG_Y=y\n"


def _minimal_board():
    return {
        "board": "test-board",
        "branch": "edge",
        "linux_family": "sunxi64",
        "arch": "arm64",
        "kernel": {
            "source": "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git",
            "branch": "branch:linux-6.18.y",
            "config": None,
            "config_path": None,
            "target_map": None,
            "patches": None,
            "patch_dir": None,
            "atf_source": None,
            "atf_branch": None,
            "atf_platform": None,
            "atf_target_map": None,
        },
        "uboot": {
            "source": "https://github.com/u-boot/u-boot.git",
            "branch": "v2025.01",
            "config": None,
            "target_map": None,
            "patches": None,
            "patch_dir": None,
            "atf_source": None,
            "atf_branch": None,
            "atf_platform": None,
            "atf_target_map": None,
        },
        "firmware": None,
        "dtb": None,
        "kernel_params": None,
        "firmware_include": None,
    }


def test_generate_prunes_stale_families_and_boards(tmp_path):
    gen = NixGenerator(tmp_path / "armbian", tmp_path / "out")
    stale_family = tmp_path / "out/nix/families/imx6/platforms.nix"
    stale_family.parent.mkdir(parents=True)
    stale_family.write_text("{}\n")
    stale_board = tmp_path / "out/nix/families/sunxi64/boards/removed-edge.nix"
    stale_board.parent.mkdir(parents=True)
    stale_board.write_text("{}\n")

    gen.generate([_minimal_board()])

    assert not stale_family.exists()
    assert not stale_family.parent.exists()
    assert not stale_board.exists()
    assert (tmp_path / "out/nix/families/sunxi64/platforms.nix").exists()


def test_sanitize_patch_name_replaces_illegal_store_characters():
    assert sanitize_patch_name("led-gpio&keyboard.patch") == "led-gpio_keyboard.patch"
    assert sanitize_patch_name("iris--s_fmt,-g_fmt.patch") == "iris--s_fmt_-g_fmt.patch"
    assert sanitize_patch_name("ok-name_1.patch") == "ok-name_1.patch"


def test_collect_patch_dir_sanitizes_copied_names(tmp_path):
    src = tmp_path / "armbian"
    patch_root = src / "patch/kernel/archive/fam-6.12"
    patch = patch_root / "patches/led-gpio&keyboard.patch"
    patch.parent.mkdir(parents=True)
    patch.write_text("diff --git a b\n")
    (patch_root / "series.conf").write_text("patches/led-gpio&keyboard.patch\n")

    gen = NixGenerator(src, tmp_path / "out")
    out = gen._collect_patch_dir("kernel", "archive/fam-6.12")

    assert out == ["patches/kernel/archive/fam-6.12/patches/led-gpio_keyboard.patch"]
    copied = tmp_path / "out/nix" / out[0]
    assert copied.read_text() == "diff --git a b\n"
