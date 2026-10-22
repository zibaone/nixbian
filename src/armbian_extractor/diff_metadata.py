import json
import sys
from pathlib import Path


def get_board_map(data):
    return {b["board"]: b for b in data if "board" in b}


def compare_metadata(old_path, new_path):
    if not Path(old_path).exists():
        print("No old metadata found for comparison.")
        return

    with open(old_path, "r") as f:
        old_data = get_board_map(json.load(f))
    with open(new_path, "r") as f:
        new_data = get_board_map(json.load(f))

    added = set(new_data.keys()) - set(old_data.keys())
    removed = set(old_data.keys()) - set(new_data.keys())
    changed = []

    for board in set(old_data.keys()) & set(new_data.keys()):
        diffs = []
        old_b = old_data[board]
        new_b = new_data[board]

        # Check Kernel
        if old_b.get("kernel", {}).get("branch") != new_b.get("kernel", {}).get(
            "branch"
        ):
            diffs.append(
                f"Kernel: {old_b.get('kernel', {}).get('branch')} -> {new_b.get('kernel', {}).get('branch')}"
            )

        # Check U-Boot
        if old_b.get("uboot", {}).get("branch") != new_b.get("uboot", {}).get("branch"):
            diffs.append(
                f"U-Boot: {old_b.get('uboot', {}).get('branch')} -> {new_b.get('uboot', {}).get('branch')}"
            )

        if diffs:
            changed.append((board, diffs))

    print(f"\n--- Metadata Change Summary ---")
    if added:
        print(
            f"➕ Added {len(added)} boards: {', '.join(list(added)[:5])}{'...' if len(added) > 5 else ''}"
        )
    if removed:
        print(
            f"❌ Removed {len(removed)} boards: {', '.join(list(removed)[:5])}{'...' if len(removed) > 5 else ''}"
        )
    if changed:
        print(f"🔄 Changed {len(changed)} boards:")
        for board, diffs in changed[:10]:
            print(f"  - {board}: {', '.join(diffs)}")
        if len(changed) > 10:
            print(f"  ... and {len(changed) - 10} more.")

    if not added and not removed and not changed:
        print("✅ No functional changes detected in metadata.")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python diff_metadata.py <old.json> <new.json>")
        sys.exit(1)
    compare_metadata(sys.argv[1], sys.argv[2])
