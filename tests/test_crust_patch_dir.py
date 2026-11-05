"""`u-boot-sunxi-crust` must only reach boards that enable crust.

`sunxi64_common.inc` sources `crust_firmware.inc`, which appends the crust
patch dir to BOOTPATCHDIR inside `if [[ -n "${CRUSTCONFIG}" ]]`. The config
parser walks the files without evaluating bash conditionals, so without an
explicit guard the append lands on every sunxi64 board and the U-Boot build
fails: those patches (H3/H5 SCP/remoteproc) do not apply to U-Boot v2025.04.
"""

from pathlib import Path

from armbian_extractor.core import NixbianExtractor


def make_extractor(tmp_path):
    src = tmp_path / "armbian"
    (src / "lib" / "functions" / "configuration").mkdir(parents=True)
    (src / "config" / "sources" / "families" / "include").mkdir(parents=True)
    (src / "config" / "boards").mkdir(parents=True)

    (src / "lib" / "functions" / "configuration" / "main-config.sh").write_text(
        'MAINLINE_KERNEL_SOURCE="https://git.kernel.org/stable/linux.git"\n'
    )
    (src / "config" / "sources" / "common.conf").write_text("")
    (src / "config" / "sources" / "families" / "testfam.conf").write_text(
        'source "${BASH_SOURCE%/*}/include/crust_firmware.inc"\n'
    )
    (
        src / "config" / "sources" / "families" / "include" / "crust_firmware.inc"
    ).write_text(
        'if [[ -n "${CRUSTCONFIG}" ]]; then\n'
        '\tBOOTPATCHDIR="${BOOTPATCHDIR} u-boot-sunxi-crust"\n'
        "fi\n"
    )
    return NixbianExtractor(src, tmp_path / "out")


def test_crust_dir_dropped_when_crustconfig_is_unset(tmp_path):
    extractor = make_extractor(tmp_path)
    (extractor.src / "config" / "boards" / "plain.csc").write_text(
        'BOARD_NAME="plain"\nBOARDFAMILY="testfam"\nBOOTPATCHDIR="v2025-sunxi"\n'
    )

    board = extractor.extract_board_config("plain", branch="edge")

    assert board["uboot"]["patch_dir"] == "v2025-sunxi"


def test_crust_dir_kept_when_crustconfig_is_set(tmp_path):
    extractor = make_extractor(tmp_path)
    (extractor.src / "config" / "boards" / "a64box.csc").write_text(
        'BOARD_NAME="a64box"\nBOARDFAMILY="testfam"\n'
        'BOOTPATCHDIR="u-boot-sunxi"\nCRUSTCONFIG="a64_defconfig"\n'
    )

    board = extractor.extract_board_config("a64box", branch="edge")

    assert board["uboot"]["patch_dir"] == "u-boot-sunxi u-boot-sunxi-crust"
