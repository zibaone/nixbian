import json
import subprocess
import re
import logging
from pathlib import Path

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger("nixbian-updater")


class NixbianUpdater:
    def __init__(self, repo="armbian/build", versions_file="versions.json"):
        self.repo = repo
        self.repo_url = f"https://github.com/{repo}.git"
        self.versions_file = Path(versions_file)
        self.versions = self._load_versions()

    def _load_versions(self):
        if self.versions_file.exists():
            with open(self.versions_file, "r") as f:
                return json.load(f)
        return {}

    def _save_versions(self):
        with open(self.versions_file, "w") as f:
            json.dump(self.versions, f, indent=2)

    def get_remote_tags(self):
        log.info(f"Fetching tags from {self.repo_url} via git ls-remote...")
        cmd = ["git", "ls-remote", "--tags", self.repo_url]
        result = subprocess.run(cmd, capture_output=True, text=True)

        tags = []
        for line in result.stdout.splitlines():
            if "^{}" in line:
                continue
            # Match major.minor releases e.g. v24.05, v25.11.1
            match = re.search(r"refs/tags/(v\d+\.\d+(?:\.\d+)?)$", line)
            if match:
                tags.append(match.group(1))
        return tags

    @staticmethod
    def sort_tags(tags):
        def key(t):
            parts = re.findall(r"\d+", t)
            if not parts:
                return [0]
            year = int(parts[0])
            if year < 100:
                year += 2000
            return [year] + [int(p) for p in parts[1:]]

        return sorted(tags, key=key, reverse=True)

    def prefetch_hash(self, tag):
        log.info(f"Prefetching hash for {tag}...")
        url = f"https://github.com/{self.repo}/archive/refs/tags/{tag}.tar.gz"

        # 1. Prefetch using nix-prefetch-url
        cmd = ["nix-prefetch-url", "--unpack", "--type", "sha256", url]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            log.error(f"Failed to prefetch {tag}: {result.stderr}")
            return None

        sha256 = result.stdout.strip()

        # 2. Convert to SRI format
        cmd_sri = ["nix", "hash", "to-sri", "--type", "sha256", sha256]
        result_sri = subprocess.run(cmd_sri, capture_output=True, text=True)
        return (
            result_sri.stdout.strip()
            if result_sri.returncode == 0
            else f"sha256-{sha256}"
        )

    def update(self, limit=5):
        all_tags = self.get_remote_tags()
        latest_tags = self.sort_tags(all_tags)[:limit]

        updated = False
        for tag in latest_tags:
            if tag not in self.versions:
                sri_hash = self.prefetch_hash(tag)
                if sri_hash:
                    self.versions[tag] = {"rev": tag, "hash": sri_hash}
                    updated = True

        if updated:
            self._save_versions()
            log.info("✔ versions.json updated successfully.")
        else:
            log.info("No new versions found.")


def main():
    updater = NixbianUpdater()
    updater.update()


if __name__ == "__main__":
    main()
