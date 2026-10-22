import argparse
import json
import logging
import sys
from dataclasses import dataclass
from typing import Any, Dict, List, Optional

log = logging.getLogger("nixbian-nvfetcher")
logging.basicConfig(level=logging.INFO)


@dataclass(frozen=True)
class Source:
    name: str
    url: str
    rev: str
    is_git: bool = True
    manual_url: Optional[str] = None

    def to_toml_lines(self) -> List[str]:
        if not self.url:
            return []
        lines = [f"[{self.name}]"]

        if self.is_git:
            if "://" in self.url:
                lines.append(f'src.manual = "{self.rev}"')
                lines.append(f'fetch.git = "{self.url}"')
                lines.append(f'rev = "{self.rev}"')
            elif "/" in self.url:  # owner/repo format
                lines.append(f'src.manual = "{self.rev}"')
                lines.append(f'fetch.git = "https://github.com/{self.url}"')
                lines.append(f'rev = "{self.rev}"')
            else:
                return []  # Invalid git source
        elif self.manual_url:
            lines.append(f'src.manual = "{self.rev}"')
            lines.append(f'fetch.url = "{self.manual_url}"')
        else:
            return []
        return lines


def sanitize_name(name: str) -> str:
    safe_name = "".join(c.lower() if c.isalnum() else "-" for c in name).strip("-")
    while "--" in safe_name:
        safe_name = safe_name.replace("--", "-")
    return safe_name


def generate_nvfetcher_toml_from_list(data: List[Dict[str, Any]], output_path: str):
    """
    Transforms a list of board metadata into a TOML configuration for nvfetcher.
    """
    sources: Dict[str, Source] = {}

    for board in data:
        # Helper to add git source
        def add_git_source(raw_name: str, url: str, rev: str):
            if not url or not url.startswith("http"):
                return

            # Filter unresolved shell variables
            if "$" in url or "$" in rev or "$" in raw_name:
                return

            # Filter generic domains
            from urllib.parse import urlparse

            parsed = urlparse(url)
            if not parsed.path or parsed.path in ["/", "/.git"]:
                return

            if "t2linux" in url:
                return

            # Rewrite source.denx.de U-Boot repos to GitHub mirror
            # (commit exists on both, GitHub is more reliable)
            if "source.denx.de/u-boot/" in url:
                url = "https://github.com/u-boot/u-boot.git"

            safe_name = sanitize_name(raw_name)
            if safe_name in sources:
                return

            clean_rev = rev.replace("tag:", "").replace("commit:", "")
            if clean_rev.startswith("branch:"):
                clean_rev = "refs/heads/" + clean_rev.replace("branch:", "")
            elif clean_rev in ["master", "main"]:
                clean_rev = "refs/heads/" + clean_rev

            if "qoriq-fm-ucode" in url and clean_rev == "refs/heads/master":
                clean_rev = "refs/heads/integration"

            if "common_drivers" in url and clean_rev == "refs/heads/master":
                clean_rev = "refs/heads/khadas-vims-5.15.y"

            if "linux-firmware" in url and clean_rev == "refs/heads/master":
                clean_rev = "refs/heads/main"

            # NOTE: several boards share the same (url, rev) (e.g. 11 families
            # use linux-7.0.y from kernel.org). Nix deduplicates in the store
            # (same rev+sha256 = same store path), so redundant entries have no
            # build cost. To deduplicate them in nvfetcher.toml, replace
            # safe_name with a canonical key derived from (url, rev) and update
            # the nvfetcher_key in all affected platforms.nix files.
            sources[safe_name] = Source(name=safe_name, url=url, rev=clean_rev)

        # 1. Kernel Source
        k = board.get("kernel", {})
        if k.get("source") and k.get("branch"):
            fam = board.get("family") or board.get("linux_family") or "generic"
            add_git_source(
                f"kernel-{fam}-{k['branch']}",
                k["source"],
                k["branch"],
            )

        # 2. U-Boot Source
        u = board.get("uboot", {})
        if u.get("source") and u.get("branch"):
            add_git_source(f"uboot-{u['branch']}", u["source"], u["branch"])

        # 3. ATF Source
        if u.get("atf_source") and u.get("atf_branch"):
            repo_name = u["atf_source"].split("/")[-1].replace(".git", "")
            add_git_source(
                f"src-{repo_name}-{u['atf_branch']}", u["atf_source"], u["atf_branch"]
            )

        # 4. Extra Sources
        extras = board.get("extra_sources", {})
        for key, src in extras.items():
            url = src["url"]
            rev = src["rev"]

            if "$" in url or "$" in rev:
                continue

            is_tarball = (
                url.endswith(".tar.gz") or url.endswith(".tar.xz") or "/archive/" in url
            )
            key_name = f"src-{url.split('/')[-1].replace('.git', '').replace('.tar.gz', '').replace('.tar.xz', '')}-{rev}"

            safe_name = sanitize_name(key_name)
            if safe_name in sources:
                continue

            # Detect GitHub archives and convert to pinned github sources
            # Example: https://github.com/armbian/firmware/archive/master.tar.gz
            github_archive_prefix = "https://github.com/"
            if url.startswith(github_archive_prefix) and "/archive/" in url:
                path_parts = url.replace(github_archive_prefix, "").split("/")
                if len(path_parts) >= 2:
                    owner = path_parts[0]
                    repo = path_parts[1]

                    # Extract correct branch/tag from archive URL if possible, otherwise fall back to rev
                    if "refs/heads/" in url:
                        branch = "refs/heads/" + url.split("refs/heads/")[-1].replace(
                            ".tar.gz", ""
                        ).replace(".tar.xz", "")
                    elif "refs/tags/" in url:
                        branch = "refs/tags/" + url.split("refs/tags/")[-1].replace(
                            ".tar.gz", ""
                        ).replace(".tar.xz", "")
                    elif "archive/" in url:
                        branch_part = (
                            url.split("archive/")[-1]
                            .replace(".tar.gz", "")
                            .replace(".tar.xz", "")
                        )
                        if "/" not in branch_part:
                            branch = "refs/heads/" + branch_part
                        else:
                            branch = rev.replace("branch:", "").replace("tag:", "")
                    else:
                        branch = rev.replace("branch:", "").replace("tag:", "")

                    # Transform into a pinned GitHub source
                    safe_name = sanitize_name(
                        f"src-{repo}-{branch.replace('refs/heads/', '').replace('refs/tags/', '')}"
                    )
                    if safe_name in sources:
                        continue

                    sources[safe_name] = Source(
                        name=safe_name, url=f"{owner}/{repo}", rev=branch, is_git=True
                    )
                    continue

            if is_tarball:
                sources[safe_name] = Source(
                    name=safe_name, url=url, rev=rev, is_git=False, manual_url=url
                )
            else:
                add_git_source(key_name, url, rev)

        # 5. Firmware Source
        f = board.get("firmware", {})
        if f.get("source") and f.get("branch"):
            repo_name = f["source"].split("/")[-1].replace(".git", "")
            add_git_source(f"src-{repo_name}-{f['branch']}", f["source"], f["branch"])

        # 6. Global Armbian Build Source (for blobs)
        add_git_source(
            "src-armbian-build", "https://github.com/armbian/build", "master"
        )

    # Build the TOML file
    lines = []
    for source in sorted(sources.values(), key=lambda s: s.name):
        lines.extend(source.to_toml_lines())
        lines.append("")

    with open(output_path, "w") as f:
        f.write("\n".join(lines))

    log.info(f"✔ Generated {len(sources)} validated sources in {output_path}")


def generate_nvfetcher_toml(metadata_path: str, output_path: str):
    with open(metadata_path, "r") as f:
        metadata = json.load(f)
    generate_nvfetcher_toml_from_list(metadata, output_path)


def main():
    parser = argparse.ArgumentParser(
        description="Generate nvfetcher.toml from Armbian metadata"
    )
    parser.add_argument("metadata", help="Path to board_metadata.json")
    parser.add_argument("output", help="Path to output nvfetcher.toml")
    parser.add_argument("--board", help="Filter for a specific board name")

    args = parser.parse_args()

    try:
        with open(args.metadata, "r") as f:
            metadata = json.load(f)
    except FileNotFoundError:
        log.error(f"Metadata file not found: {args.metadata}")
        sys.exit(1)

    if args.board:
        log.info(f"Filtering metadata for board: {args.board}")
        metadata = [b for b in metadata if b.get("board") == args.board]
        if not metadata:
            log.error(f"Board '{args.board}' not found in metadata!")
            sys.exit(1)

    generate_nvfetcher_toml_from_list(metadata, args.output)


if __name__ == "__main__":
    main()
