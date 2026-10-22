"""Tests for the `check_hw_caps` gate.

The trap these tests lock down: a node can carry the right `compatible` and
still be `status = "disabled"` (Armbian dtsi `0042` + board enablement `0043`); a
plain grep of the compatible then passes while HDMI is off. And a
`status = "disabled"` in a CHILD node must not disqualify the parent.
"""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import check_hw_caps as caps  # noqa: E402

DTS = """/dts-v1/;

/ {
\tcompatible = "allwinner,sun50i-h618";

\tsoc {
\t\tvideo-codec@1c0e000 {
\t\t\tcompatible = "allwinner,sun50i-h616-video-engine";
\t\t\treg = <0x01c0e000 0x2000>;
\t\t\tstatus = "disabled";
\t\t\tiommus = <&iommu 1>;
\t\t};

\t\thdmi@6000000 {
\t\t\tcompatible = "allwinner,sun50i-h616-dw-hdmi";
\t\t\tstatus = "okay";
\t\t\tports {
\t\t\t\t#address-cells = <1>;
\t\t\t\tport@0 {
\t\t\t\t\treg = <0>;
\t\t\t\t\tremote-endpoint = <&tcon_top_hdmi_in_hdmi>;
\t\t\t\t};
\t\t\t};
\t\t};

\t\tde33 {
\t\t\tcompatible = "allwinner,sun50i-h616-display-engine";
\t\t\ttcon-lcd {
\t\t\t\tcompatible = "allwinner,sun50i-h616-tcon-lcd";
\t\t\t\tstatus = "disabled";
\t\t\t};
\t\t};
\t};
};
"""


def test_node_okay():
    assert caps._node_state(DTS, "allwinner,sun50i-h616-dw-hdmi") == "okay"


def test_node_disabled():
    assert caps._node_state(DTS, "allwinner,sun50i-h616-video-engine") == "disabled"


def test_node_absent():
    assert caps._node_state(DTS, "allwinner,sun50i-h616-mali") == "absent"


def test_disabled_child_does_not_disable_parent():
    """`tcon-lcd` is disabled in `de33`: the parent stays okay."""
    assert caps._node_state(DTS, "allwinner,sun50i-h616-display-engine") == "okay"


def test_own_block_strips_nested_nodes():
    block = '{ compatible = "a"; child { status = "disabled"; }; }'
    own = caps._own_block(block)
    assert '"a"' in own
    assert "disabled" not in own


def test_required_table_targets_real_compatibles():
    reqs = {c for c, _ in caps.REQUIRED_COMPATIBLES["orangepizero3"]}
    assert "allwinner,sun50i-h616-video-engine" in reqs
    assert "allwinner,sun50i-h616-dw-hdmi" in reqs


def test_board_key_split_keeps_hyphenated_board_names():
    assert caps._split_board_key("orangepizero3-edge") == ("orangepizero3", "edge")
    assert caps._split_board_key("orangepi5-plus-edge") == ("orangepi5-plus", "edge")
    assert caps._split_board_key("nanopim1") == ("nanopim1", "")
