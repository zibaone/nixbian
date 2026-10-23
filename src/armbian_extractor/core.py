import json
import logging
from pathlib import Path
from .parser import NixbianConfigParser
import os
import subprocess

import os
import subprocess
import importlib.resources


def relativize_path(value, src):
    """Remove the absolute Armbian tree prefix from an emitted path.

    Armbian variables (``UBOOT_TARGET_MAP``, ``ATF_TARGET_MAP``) and the kernel
    config path embed absolute paths to the source tree. Emitted as-is, they
    point to the generation machine's store and make ``metadata/``
    non-portable. We emit paths relative to the Armbian root, including when
    the path appears in the middle of a string (``UBOOT_TARGET_MAP``).
    """
    if not isinstance(value, str) or not value:
        return value
    prefix = f"{src}/"
    if value.startswith(prefix):
        return value[len(prefix) :]
    return value.replace(prefix, "")


# Simple persistent cache for prefetch results
# We use importlib to correctly find the resource within the package
try:
    # Assuming 'armbian_extractor' is the package name
    CACHE_FILE = importlib.resources.files("armbian_extractor") / "prefetch_cache.json"
except Exception:
    # Fallback for local dev execution
    CACHE_FILE = Path(__file__).parent / "prefetch_cache.json"

PREFETCH_CACHE = {}


def load_cache():
    global PREFETCH_CACHE
    local_cache = Path("prefetch_cache.json")
    if local_cache.is_file():
        try:
            with open(local_cache, "r") as f:
                PREFETCH_CACHE = json.load(f)
            print(
                f"Loaded {len(PREFETCH_CACHE)} entries from local cache: {local_cache.resolve()}"
            )
            return
        except Exception as e:
            print(f"Warning: Failed to load local cache: {e}")

    try:
        if CACHE_FILE.is_file():
            with CACHE_FILE.open("r") as f:
                PREFETCH_CACHE = json.load(f)
            print(f"Loaded {len(PREFETCH_CACHE)} entries from cache: {CACHE_FILE}")
        else:
            print(f"Cache file not found at {CACHE_FILE}")
    except Exception as e:
        print(f"Warning: Failed to load prefetch cache: {e}")


def save_cache():
    local_cache = Path("prefetch_cache.json")
    try:
        with open(local_cache, "w") as f:
            json.dump(PREFETCH_CACHE, f, indent=4)
        print(
            f"Saved {len(PREFETCH_CACHE)} entries to local cache: {local_cache.resolve()}"
        )
    except Exception as e:
        pass


def normalize_rev(rev):
    if not rev:
        return ""
    rev = rev.lower().strip()
    for prefix in ["refs/heads/", "refs/tags/", "branch:", "tag:", "commit:"]:
        if rev.startswith(prefix):
            rev = rev[len(prefix) :]
    return rev


GENERATED_CACHE = {}

# Substitutable Armbian variables in parsed fields (LINUXCONFIG, …).
# Some boards define LINUXCONFIG via ${LINUXFAMILY}/${BOARD}: without
# substitution, the generated config path does not exist and the kernel config
# is silently missing (no "armbian" tier for the family).
ARMBIAN_EXPANDABLE_VARS = ("LINUXFAMILY", "BOARD", "BRANCH", "ARCH")


def expand_armbian_vars(value, **vars):
    """Replace ${VAR} / $VAR with known values (LINUXFAMILY, BOARD, …)."""
    if not value:
        return value
    out = value
    for key in ARMBIAN_EXPANDABLE_VARS:
        val = vars.get(key.lower()) or vars.get(key) or ""
        out = out.replace("${%s}" % key, str(val)).replace("$%s" % key, str(val))
    return out


def load_generated_json_cache():
    global GENERATED_CACHE
    possible_paths = [
        Path("metadata/sources/generated.json"),
        Path("../metadata/sources/generated.json"),
        Path(__file__).parent.parent.parent / "metadata/sources/generated.json",
    ]
    for p in possible_paths:
        if p.is_file():
            try:
                with open(p, "r") as f:
                    data = json.load(f)
                for entry in data.values():
                    src = entry.get("src")
                    if src and src.get("url") and src.get("sha256"):
                        url = src["url"].lower().strip()
                        if url.endswith(".git"):
                            url = url[:-4]

                        # Add by normalized rev
                        norm_rev = normalize_rev(src.get("rev"))
                        if norm_rev:
                            GENERATED_CACHE[(url, norm_rev)] = src["sha256"]

                        # Also check the top-level version field
                        version = entry.get("version")
                        if version:
                            norm_ver = normalize_rev(version)
                            GENERATED_CACHE[(url, norm_ver)] = src["sha256"]
                print(
                    f"Loaded {len(GENERATED_CACHE)} mapping entries from generated.json"
                )
                return
            except Exception as e:
                print(f"Warning: Failed to load generated.json cache: {e}")


def get_nix_hash(url, rev, force=False):
    """
    Prefetch a URL+Rev using nix-prefetch-url and return SRI hash.
    Uses local cache and generated.json to avoid repeated downloads.
    """
    if not url or not rev:
        return None

    # Normalise inputs
    norm_url = url.lower().strip()
    if norm_url.endswith(".git"):
        norm_url = norm_url[:-4]
    norm_rev = normalize_rev(rev)

    # 1. Check generated.json cache
    if not force and (norm_url, norm_rev) in GENERATED_CACHE:
        sri_hash = GENERATED_CACHE[(norm_url, norm_rev)]
        # Save to PREFETCH_CACHE for subsequent lookups
        cache_key = f"{url}@{rev}"
        PREFETCH_CACHE[cache_key] = sri_hash
        return sri_hash

    # 2. Check local prefetch cache
    cache_key = f"{url}@{rev}"
    if not force and cache_key in PREFETCH_CACHE:
        return PREFETCH_CACHE[cache_key]

    # 3. Determine if we should skip active prefetching (e.g. in CI or via env var)
    skip_prefetch = (
        os.environ.get("CI") == "true"
        or os.environ.get("GITHUB_ACTIONS") == "true"
        or os.environ.get("NIXBIAN_SKIP_PREFETCH") == "1"
    )

    if skip_prefetch:
        print(f"  -- Skipping prefetch for {url} ({rev}) in CI/offline mode")
        return None

    print(f"  --> Prefetching {url} ({rev})... this may take a while")

    # 4. Nix Prefetch
    try:
        if url.endswith(".git") or "github.com" in url:
            cmd = [
                "nix",
                "--extra-experimental-features",
                "nix-command flakes",
                "run",
                "nixpkgs#nix-prefetch-git",
                "--",
                "--url",
                url,
                "--rev",
                rev,
            ]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            data = json.loads(result.stdout)
            sha256_hash = data["sha256"]
        else:
            # Fallback for simple URLs
            cmd = ["nix-prefetch-url", "--unpack", "--type", "sha256", url]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            sha256_hash = result.stdout.strip()

        # 5. Convert to SRI
        cmd_sri = ["nix", "hash", "to-sri", "--type", "sha256", sha256_hash]
        result_sri = subprocess.run(cmd_sri, capture_output=True, text=True, check=True)
        sri_hash = result_sri.stdout.strip()

        # Cache and return
        PREFETCH_CACHE[cache_key] = sri_hash
        save_cache()
        return sri_hash

    except (subprocess.CalledProcessError, FileNotFoundError, Exception) as e:
        print(f"  !! Prefetch skipped for {url} ({e})")
        return None


# Load caches on module import
load_cache()
load_generated_json_cache()

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
log = logging.getLogger("nixbian")


def load_previous_metadata_cache(out_dir):
    """Reinject hashes already present in <out_dir>/board_metadata.json.

    Without this, a regeneration without prefetch (NIXBIAN_SKIP_PREFETCH=1, CI,
    or a network failure) rewrites `hash: null` for every unpinned source:
    already-resolved hashes would be lost and subsequent builds would break
    (fetch without hash). Entries from the output file therefore act as a cache.
    """
    path = Path(out_dir) / "board_metadata.json"
    if not path.is_file():
        return 0
    try:
        entries = json.loads(path.read_text())
    except Exception as e:
        log.warning(f"Failed to read previous metadata for hash reuse: {e}")
        return 0
    if isinstance(entries, dict):
        entries = list(entries.values())

    added = 0
    for entry in entries:
        if not isinstance(entry, dict):
            continue
        uboot = entry.get("uboot") or {}
        kernel = entry.get("kernel") or {}
        major_minor = kernel.get("major_minor") or ""
        candidates = [
            (uboot.get("source"), uboot.get("branch"), uboot.get("source_hash")),
            (uboot.get("atf_source"), uboot.get("atf_branch"), uboot.get("atf_hash")),
            (kernel.get("source"), kernel.get("branch"), kernel.get("hash")),
        ]
        for url, rev, sri in candidates:
            if not url or not rev or not sri:
                continue
            if "${KERNEL_MAJOR_MINOR}" in rev and major_minor:
                rev = rev.replace("${KERNEL_MAJOR_MINOR}", major_minor)
            norm_url = url.lower().strip()
            if norm_url.endswith(".git"):
                norm_url = norm_url[:-4]
            norm_rev = normalize_rev(rev)
            if norm_rev and (norm_url, norm_rev) not in GENERATED_CACHE:
                GENERATED_CACHE[(norm_url, norm_rev)] = sri
                added += 1
    if added:
        log.info(f"Reused {added} hash(es) from previous {path.name}")
    return added


class NixbianExtractor:
    def __init__(self, armbian_src, out_dir, refresh_kernel_versions=False):
        self.src = Path(armbian_src).resolve()
        self.out_dir = Path(out_dir).resolve()
        self.out_dir.mkdir(parents=True, exist_ok=True)
        self.refresh_kernel_versions = refresh_kernel_versions

        # Load overrides
        self.overrides = {}
        overrides_path = Path(__file__).parent / "overrides.json"
        if overrides_path.exists():
            try:
                self.overrides = json.load(overrides_path.open())
                log.info(f"Loaded {len(self.overrides)} board overrides")
            except Exception as e:
                log.warning(f"Failed to load overrides: {e}")

        # We still rely on some existing python scripts for the complex inventory lists
        # But we will handle the metadata extraction more safely
        self.parser = NixbianConfigParser(self.src)

        # Reuse already-resolved hashes (avoid losing them without prefetch)
        load_previous_metadata_cache(self.out_dir)

    def extract_board_config(self, board_name, branch="current"):
        """
        Main extraction logic for a single board.
        1. Sources base Armbian defaults to capture global URLs and blob settings.
        2. Locates and parses the board-specific configuration.
        3. Scans for BOARDFAMILY and parses family-specific includes.
        4. Performs an 'Aggressive Scan' of all context variables to find anything
           that looks like a Git repo or a URL (firmwares, rkbin, etc.).
        5. Returns a structured dictionary ready for JSON/Nix export.
        """
        # Reset parser context for a fresh board, but keep global env like SRC
        self.parser = NixbianConfigParser(self.src, branch=branch)

        # 1. Source base Armbian defaults (crucial for blobs and default URLs)
        base_defaults = [
            self.src / "lib" / "functions" / "configuration" / "main-config.sh",
            self.src / "lib" / "config-default.sh",
            self.src / "config" / "sources" / "common.conf",
        ]
        for base in base_defaults:
            if base.exists():
                log.info(f"Parsing base defaults: {base.name}")
                self.parser.parse_file(base)

        # 2. Find Board Config (trying all extensions)
        extensions = [".conf", ".csc", ".tvb", ".wip", ".eos", ".wip", ".csc"]
        board_conf = None

        # Try core config first
        for ext in extensions:
            path = self.src / "config" / "boards" / f"{board_name}{ext}"
            if path.exists():
                board_conf = path
                break

        if not board_conf:
            # Try userpatches
            for ext in extensions:
                path = (
                    self.src
                    / "userpatches"
                    / "config"
                    / "boards"
                    / f"{board_name}{ext}"
                )
                if path.exists():
                    board_conf = path
                    break

        if not board_conf:
            log.warning(f"Board config not found for {board_name}")
            return None

        # 3. Parse Board Config
        log.info(f"Parsing board config: {board_conf.name} (branch={branch})")
        self.parser.parse_file(board_conf)

        # 4. Explicitly source family if defined but not sourced
        board_family = self.parser.get("BOARDFAMILY")
        if board_family:
            family_conf = (
                self.src / "config" / "sources" / "families" / f"{board_family}.conf"
            )
            if family_conf.exists():
                log.info(
                    f"Found BOARDFAMILY={board_family}, parsing {family_conf.name}"
                )
                self.parser.parse_file(family_conf)

        # 5. Extract extra sources (AGGRESSIVE SCAN)
        # Any variable ending in SOURCE, REPO, URL, or starting with BL31, TEE, SCP
        extra_sources = {}
        # List of global constant keys we want to exclude from individual board metadata
        # because they are just base URLs, not specific repositories.
        GLOBAL_IGNORE = [
            "GITHUB_SOURCE",
            "GIT_SOURCE",
            "MAINLINE_KERNEL_SOURCE",
            "MAINLINE_UBOOT_SOURCE",
        ]

        source_keys = [
            k
            for k in self.parser.context.keys()
            if (
                any(k.endswith(suffix) for suffix in ["SOURCE", "REPO", "URL"])
                or any(k.startswith(prefix) for prefix in ["BL31", "TEE", "SCP", "DDR"])
            )
            and k not in GLOBAL_IGNORE
        ]

        for k in source_keys:
            val = self.parser.get(k)
            # Only include if it's a real repository URL (not just a base domain)
            if (
                val
                and isinstance(val, str)
                and (
                    val.startswith("http")
                    or "github.com" in val
                    or val.endswith(".git")
                )
            ):
                # Basic heuristic: ignore if it's just a root domain (length check or common base)
                if len(val.strip("/").split("/")) < 4 and not val.endswith(".git"):
                    continue

                # Check if there's a corresponding BRANCH or REV variable
                branch_key = (
                    k.replace("SOURCE", "BRANCH")
                    .replace("URL", "BRANCH")
                    .replace("REPO", "BRANCH")
                )
                if branch_key not in self.parser.context:
                    branch_key = (
                        k.replace("SOURCE", "REV")
                        .replace("URL", "REV")
                        .replace("REPO", "REV")
                    )

                rev = self.parser.get(branch_key) or "master"
                extra_sources[k] = {"url": val, "rev": rev}

        # 6. Extract key data
        linux_family = self.parser.get("LINUXFAMILY")

        # Apply Defaults (Mainline)
        kernel_source = self.parser.get("KERNELSOURCE")
        kernel_branch = self.parser.get("KERNELBRANCH")
        kernel_major_minor = self.parser.get("KERNEL_MAJOR_MINOR")

        if not kernel_source:
            kernel_source = (
                self.parser.get("MAINLINE_KERNEL_SOURCE")
                or "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
            )

        if not kernel_branch and kernel_major_minor:
            kernel_branch = f"branch:linux-{kernel_major_minor}.y"

        arch = self.parser.get("ARCH") or self.parser.get("ARCHITECTURE")

        # LINUXCONFIG may contain ${LINUXFAMILY}/${BOARD}: without substitution,
        # the config path does not resolve and the family loses its armbian tier.
        linux_config = expand_armbian_vars(
            self.parser.get("LINUXCONFIG"),
            linuxfamily=linux_family,
            board=board_name,
            branch=branch,
            arch=arch,
        )

        data = {
            "board": board_name,
            "branch": branch,
            "linux_family": linux_family,
            "arch": arch,
            "kernel": {
                "source": kernel_source,
                "branch": kernel_branch,
                "major_minor": kernel_major_minor,
                "config": linux_config,
                "config_path": relativize_path(
                    str(self.src / "config" / "kernel" / f"{linux_config}.config"),
                    self.src,
                )
                if linux_config
                else None,
                "patch_dir": self.parser.get("KERNELPATCHDIR"),
            },
            "uboot": {
                "source": self.parser.get("BOOTSOURCE"),
                "branch": self.parser.get("BOOTBRANCH"),
                "config": self.parser.get("BOOTCONFIG"),
                "target_map": relativize_path(
                    self.parser.get("UBOOT_TARGET_MAP"), self.src
                ),
                "patches": self.parser.get("BOOTPATCHES"),
                "patch_dir": self.parser.get("BOOTPATCHDIR"),
                "atf_source": self.parser.get("ATFSOURCE"),
                "atf_branch": self.parser.get("ATFBRANCH"),
                "atf_platform": self.parser.get("ATF_PLAT"),
                "atf_target_map": relativize_path(
                    self.parser.get("ATF_TARGET_MAP"), self.src
                ),
            },
            "extra_sources": extra_sources,
            # `DEFAULT_DEVICE_TREE` is the *U-Boot* device tree name, which need
            # not match the kernel's DTS (e.g. meson-g12b-libretech-cc vs
            # meson-g12b-a311d-libretech-cc); building the kernel with it fails
            # with "No rule to make target ...dtb". `BOOT_FDT_FILE` is what
            # Armbian actually boots, i.e. the kernel name.
            "dtb": self.parser.get("BOOT_FDT_FILE")
            or self.parser.get("DEFAULT_DEVICE_TREE"),
            "kernel_params": self.parser.get("KERNEL_PARAMS"),
            "firmware": {
                "source": self.parser.get("FIRMWARE_URL")
                or "https://github.com/armbian/firmware",
                "branch": self.parser.get("FIRMWARE_BRANCH") or "master",
            },
        }

        # 6. Apply Overrides BEFORE Prefetching
        if board_name in self.overrides:
            board_ov = self.overrides[board_name]
            # Branch-specific overrides
            if branch in board_ov:
                self._deep_update(data, board_ov[branch])
            # Global overrides for this board
            if "all" in board_ov:
                self._deep_update(data, board_ov["all"])

        # 7. Prefetch Hashes (using values potentially updated by overrides)
        uboot_hash = None
        if data["uboot"].get("source") and data["uboot"].get("branch"):
            fetch_rev = (
                data["uboot"]["branch"].replace("tag:", "").replace("branch:", "")
            )
            uboot_hash = get_nix_hash(data["uboot"]["source"], fetch_rev)
        data["uboot"]["source_hash"] = uboot_hash

        atf_hash = None
        if data["uboot"].get("atf_source") and data["uboot"].get("atf_branch"):
            fetch_rev = (
                data["uboot"]["atf_branch"].replace("tag:", "").replace("branch:", "")
            )
            atf_hash = get_nix_hash(data["uboot"]["atf_source"], fetch_rev)
        data["uboot"]["atf_hash"] = atf_hash

        # 8. Prefetch Kernel Hash
        kernel_hash = None
        if data["kernel"].get("source") and data["kernel"].get("branch"):
            fetch_rev = (
                data["kernel"]["branch"].replace("tag:", "").replace("branch:", "")
            )
            major_minor = data["kernel"].get("major_minor")
            if major_minor and "${KERNEL_MAJOR_MINOR}" in fetch_rev:
                fetch_rev = fetch_rev.replace("${KERNEL_MAJOR_MINOR}", major_minor)
            kernel_hash = get_nix_hash(data["kernel"]["source"], fetch_rev)
        data["kernel"]["hash"] = kernel_hash

        return data

    def _deep_update(self, base, update):
        """Recursively update a dictionary."""
        for k, v in update.items():
            if isinstance(v, dict) and k in base and isinstance(base[k], dict):
                self._deep_update(base[k], v)
            else:
                base[k] = v

    def quick_get_board_family(self, board_name):
        """Quickly reads the board config file to find the BOARDFAMILY or LINUXFAMILY without full extraction."""
        extensions = [".conf", ".csc", ".tvb", ".wip", ".eos"]
        board_paths = [
            self.src / "config" / "boards" / f"{board_name}{ext}" for ext in extensions
        ]
        userpatches_dir = os.environ.get("USERPATCHES_PATH")
        if userpatches_dir:
            board_paths.extend(
                [
                    Path(userpatches_dir) / "config" / "boards" / f"{board_name}{ext}"
                    for ext in extensions
                ]
            )

        for path in board_paths:
            if path.exists():
                try:
                    with open(path, "r", encoding="utf-8", errors="ignore") as f:
                        for line in f:
                            if "#" in line:
                                line = line.split("#", 1)[0]
                            line = line.strip()
                            if not line:
                                continue
                            if "BOARDFAMILY=" in line or "LINUXFAMILY=" in line:
                                if "BOARDFAMILY=" in line:
                                    val = line.split("BOARDFAMILY=", 1)[1].strip()
                                else:
                                    val = line.split("LINUXFAMILY=", 1)[1].strip()
                                # Strip quotes if present
                                if (val.startswith('"') and val.endswith('"')) or (
                                    val.startswith("'") and val.endswith("'")
                                ):
                                    val = val[1:-1]
                                return val
                except Exception:
                    pass
        return "generic"

    def enrich_exact_versions(self, enriched_data):
        """Fetches exact kernel versions from remote Makefiles and caches them."""
        log.info("Fetching exact kernel versions from remote Makefiles...")
        from urllib.parse import urlparse
        import urllib.request
        import subprocess
        import re

        def get_raw_file_url(repo_url, rev, path="Makefile"):
            parsed = urlparse(repo_url)
            host = parsed.netloc
            url_path = parsed.path.strip("/")
            if url_path.endswith(".git"):
                if "git.kernel.org" not in host:
                    url_path = url_path[:-4]
            if "github.com" in host:
                return f"https://raw.githubusercontent.com/{url_path}/{rev}/{path}"
            elif "git.kernel.org" in host:
                return f"https://git.kernel.org/{url_path}/plain/{path}?h={rev}"
            elif "gitlab" in host:
                return f"https://{host}/{url_path}/-/raw/{rev}/{path}"
            elif "source.denx.de" in host:
                return f"https://source.denx.de/{url_path}/-/raw/{rev}/{path}"
            else:
                return f"https://{host}/{url_path}/-/raw/{rev}/{path}"

        def fetch_makefile_version(repo_url, branch_or_tag):
            rev = branch_or_tag.replace("branch:", "").replace("tag:", "")
            url = get_raw_file_url(repo_url, rev, "Makefile")
            try:
                res = subprocess.run(
                    ["curl", "-sL", "--connect-timeout", "5", url],
                    capture_output=True,
                    text=True,
                )
                content = res.stdout
                if res.returncode == 0 and content:
                    v_match = re.search(
                        r"^VERSION\s*=\s*([0-9]+)", content, re.MULTILINE
                    )
                    p_match = re.search(
                        r"^PATCHLEVEL\s*=\s*([0-9]+)", content, re.MULTILINE
                    )
                    s_match = re.search(
                        r"^SUBLEVEL\s*=\s*([0-9]+)", content, re.MULTILINE
                    )
                    if v_match and p_match and s_match:
                        return (
                            f"{v_match.group(1)}.{p_match.group(1)}.{s_match.group(1)}"
                        )
            except Exception as e:
                pass
            return None

        version_cache = {}
        cache_path = self.out_dir / "kernel-versions.json"
        cache = {}
        if cache_path.exists():
            try:
                cache = json.loads(cache_path.read_text())
            except Exception as e:
                log.warning(f"Cache des versions noyau illisible ({cache_path}): {e}")

        cache_changed = False
        for item in enriched_data:
            k = item.get("kernel")
            if not k:
                continue
            source = k.get("source")
            branch = k.get("branch")
            major_minor = k.get("major_minor")
            if not source or not branch:
                continue

            # Replace variable template if present
            if major_minor and "${KERNEL_MAJOR_MINOR}" in branch:
                branch = branch.replace("${KERNEL_MAJOR_MINOR}", major_minor)

            cache_key = (source, branch)
            if cache_key not in version_cache:
                key = f"{source}|{branch}"
                if not self.refresh_kernel_versions and key in cache:
                    version_cache[cache_key] = cache[key]
                else:
                    exact_ver = fetch_makefile_version(source, branch)
                    # In refresh mode, a network failure must not overwrite a
                    # value already known.
                    if exact_ver is None:
                        exact_ver = cache.get(key)
                    version_cache[cache_key] = exact_ver
                    if cache.get(key) != exact_ver:
                        cache[key] = exact_ver
                        cache_changed = True
                    if exact_ver:
                        log.info(
                            f"  --> {source} @ {branch} => exact version: {exact_ver}"
                        )
                    else:
                        log.warning(
                            f"  !! Could not fetch exact version for {source} @ {branch}"
                        )

            k["exact_version"] = version_cache[cache_key]

        if cache_changed or not cache_path.exists():
            cache_path.write_text(json.dumps(cache, indent=2, sort_keys=True) + "\n")

    def process_targets(self, targets_json_path, boards=None, families=None):
        """
        Reads the targets JSON (output of targets-compositor) and enriches it
        with detailed source metadata.
        """
        with open(targets_json_path, "r") as f:
            targets = json.load(f)

        enriched_data = []

        # Track (board, branch) to avoid duplicates
        processed = set()

        for target in targets:
            board_name = target["vars"]["BOARD"]
            branch = target["vars"]["BRANCH"]

            # Filtering
            if branch == "bleedingedge":
                continue
            if boards and board_name not in boards:
                continue

            # Family pre-filtering (extremely fast)
            if families:
                board_family = self.quick_get_board_family(board_name)
                if board_family not in families:
                    continue

            key = (board_name, branch)
            if key in processed:
                continue

            log.info(f"Processing metadata for board: {board_name} [{branch}]")
            metadata = self.extract_board_config(board_name, branch=branch)
            if not metadata:
                continue

            # Family filtering (post-extraction)
            if families and metadata.get("linux_family") not in families:
                continue

            enriched_data.append(metadata)
            processed.add(key)

        # Fetch exact kernel versions
        self.enrich_exact_versions(enriched_data)

        # Write result
        out_file = self.out_dir / "board_metadata.json"
        with open(out_file, "w") as f:
            json.dump(enriched_data, f, indent=4)

        log.info(f"✔ Metadata extraction complete: {out_file}")
        return out_file
