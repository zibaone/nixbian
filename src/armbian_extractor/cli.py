import argparse
import sys
import json
import subprocess
from pathlib import Path
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger("nixbian")

from .core import NixbianExtractor


def run_legacy_compositor(src, outdir):
    """
    Runs the legacy targets-compositor.py to get the base list of targets.
    This is temporarily needed until we fully port the inventory logic.
    """
    cmd = [
        sys.executable,
        str(Path(src) / "lib/tools/info/targets-compositor.py"),
        str(Path(outdir) / "all_boards_all_branches.json"),
        str(Path(outdir) / "all_userspace_inventory.json"),
        str(Path(src) / "config/templates/targets-default.yaml"),
    ]

    # The two inventories do not share a schema: board-inventory.py returns a
    # dict keyed by board, userspace-inventory.py returns a list. Confusing them
    # produced two byte-identical files and an invalid userspace inventory for
    # the compositor.
    inventory_script = Path(src) / "lib/tools/info/board-inventory.py"
    userspace_script = Path(src) / "lib/tools/info/userspace-inventory.py"
    if not userspace_script.exists():
        # Compatibility with older Armbian versions.
        userspace_script = inventory_script

    env = {"SRC": src, "PYTHONPATH": ":".join(sys.path)}

    with open(Path(outdir) / "all_userspace_inventory.json", "w") as f:
        subprocess.run(
            [sys.executable, str(userspace_script)],
            stdout=f,
            env=env,
            check=True,
        )

    with open(Path(outdir) / "all_boards_all_branches.json", "w") as f:
        subprocess.run(
            [sys.executable, str(inventory_script)],
            stdout=f,
            env=env,
            check=True,
        )

    # Run compositor
    with open(Path(outdir) / "all-targets.json", "w") as f:
        subprocess.run(
            cmd,
            stdout=f,
            env=env,
            check=True,
        )

    return Path(outdir) / "all-targets.json"


def main():
    parser = argparse.ArgumentParser(
        description="Extract Armbian metadata using Armbian's Python modules + Bash Parser"
    )
    parser.add_argument(
        "--armbian-src", required=True, help="Path to Armbian source tree"
    )
    parser.add_argument("--outdir", required=True, help="Output directory")
    parser.add_argument("--boards", nargs="+", help="Only process these boards")
    parser.add_argument("--families", nargs="+", help="Only process these families")
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Enable verbose logging"
    )
    parser.add_argument(
        "--armbian-version",
        default=None,
        help=(
            "Armbian version of the pin (e.g. v26.5.1) — stamped into "
            "board_metadata.json and the passthru.armbianVersion of packages. "
            "Do NOT read the tree's VERSION file (26.05.0-trunk on v26.5.1)."
        ),
    )
    parser.add_argument(
        "--refresh-kernel-versions",
        action="store_true",
        help=(
            "Refresh metadata/kernel-versions.json from the upstream Makefiles. "
            "By default the committed cache is reused (offline and deterministic "
            "regeneration)."
        ),
    )

    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
        log.debug("Verbose logging enabled")

    # Ensure output directory exists
    outdir = Path(args.outdir).resolve()
    outdir.mkdir(parents=True, exist_ok=True)
    log.info(f"Output directory: {outdir}")

    # 1. Generate Base Targets (Legacy Wrapper)
    # Note: For now, we always generate the full inventory as it's fast
    log.info("Step 1/3: Generating base targets list (running Armbian scripts)...")
    targets_json = run_legacy_compositor(args.armbian_src, args.outdir)
    log.debug(f"Targets inventory created at {targets_json}")

    # 2. Extract detailed metadata and generate Nix
    log.info("Step 2/3: Extracting detailed source metadata (Bash parsing)...")
    extractor = NixbianExtractor(
        args.armbian_src,
        args.outdir,
        refresh_kernel_versions=args.refresh_kernel_versions,
    )
    metadata_json = extractor.process_targets(
        targets_json, boards=args.boards, families=args.families
    )
    log.debug(f"Full metadata JSON created at {metadata_json}")

    # 3. Generate Nix expressions
    log.info("Step 3/3: Generating Nix expressions and collecting assets...")
    from .generator import NixGenerator

    with open(metadata_json, "r") as f:
        metadata_list = json.load(f)

    # (b) Armbian version from the pin: stamped into board_metadata.json
    # (field `armbian_version`) then frozen in passthru.armbianVersion.
    stamped = NixGenerator.stamp_armbian_version(metadata_list, args.armbian_version)
    if stamped:
        Path(metadata_json).write_text(json.dumps(metadata_list, indent=4) + "\n")
        log.info(
            f"Stamped armbian_version={args.armbian_version} on {stamped} board entries"
        )

    generator = NixGenerator(
        args.armbian_src, args.outdir, armbian_version=args.armbian_version
    )
    generator.generate(metadata_list)

    log.info(f"✔ Successfully completed! Outputs generated in: {outdir}/nix/")


if __name__ == "__main__":
    main()
