# List all recipes
default:
    @just --list

# Update versions.json with the latest Armbian tags from GitHub
update-versions:
    nix run .#update-versions

# Regenerate the local metadata folder from the latest Armbian version
refresh-metadata:
    #!/usr/bin/env bash
    LATEST=$(jq -r 'keys | .[]' versions.json | sort -V | tail -n 1)
    echo "Refreshing metadata for $LATEST..."
    
    # Save old metadata for comparison
    cp metadata/board_metadata.json metadata/board_metadata.json.old 2>/dev/null || true
    
    # Build Armbian source for the latest version
    # NB: the attribute contains dots (ex: armbian-source-v26.5.1); the quotes
    # must survive the flake refs parser, otherwise the dots are read as nested
    # attribute segments ("does not provide attribute ...").
    nix build ".#\"armbian-source-${LATEST}\"" --out-link result-source
    
    # Run the extractor to regenerate metadata. By default the cache
    # kernel-versions.json is reused; REFRESH_KERNEL_VERSIONS=1 forces
    # reading the upstream Makefiles (Armbian upgrade).
    nix run . -- --armbian-src result-source --outdir metadata --armbian-version "$LATEST" \
        ${REFRESH_KERNEL_VERSIONS:+--refresh-kernel-versions}

    # The generator writes readable Nix but not necessarily nixfmt output; the
    # check-format gate runs in --check mode, so the artifact is formatted before testing.
    just format
    
    # Clean up symlink
    rm -f result-source
    
    # Show diff
    if [ -f metadata/board_metadata.json.old ]; then
        python3 src/armbian_extractor/diff_metadata.py metadata/board_metadata.json.old metadata/board_metadata.json
        rm metadata/board_metadata.json.old
    fi
    
    echo "✔ Local metadata updated to $LATEST"
    just check

# Full alignment with the latest Armbian releases (Update versions + Refresh local metadata + Fetch hashes)
upgrade: update-versions
    REFRESH_KERNEL_VERSIONS=1 just refresh-metadata
    just fetch-hashes

# Generate nvfetcher.sources.toml (branches) from extracted metadata — Stage 1
gen-nvfetcher:
    python3 src/armbian_extractor/nvgen.py metadata/board_metadata.json metadata/nvfetcher.sources.toml

# Resolve branches to pinned commits — Stage 2 (generates nvfetcher.lock.toml)
resolve:
    python3 scripts/resolve_lock.py

# Fetch hashes for a specific board only (fast)
fetch-board board: resolve
    nvfetcher -c metadata/nvfetcher.lock.toml -o metadata/sources

# Fetch all source hashes using nvfetcher (Stage 1 → 2 → nvfetcher)
# NOTE: gen-nvfetcher is NOT in the dependencies — the sources.toml
# is committed in the repo with all the entries. gen-nvfetcher
# regenerates from board_metadata.json (useful for an Armbian upgrade,
# not for the daily hashes).
fetch-hashes: resolve
    nvfetcher -c metadata/nvfetcher.lock.toml -o metadata/sources

# Lock diff: shows which sources still use branches vs pinned commits
lock-diff:
    python3 scripts/lock_diff.py

# Check evaluation, formatting, and run tests
check: check-format
    @echo "🔍 Checking drift between templates and generated metadata..."
    just check-drift
    @echo "🔍 Checking Orange Pi Zero 3 (Allwinner H618)..."
    nix eval .#orangepizero3-edge
    @echo "🔍 Checking Orange Pi 5 (Rockchip RK3588)..."
    nix eval .#orangepi5-edge
    @echo "🔍 Checking Raspberry Pi 4 (BCM2711)..."
    nix eval .#rpi4b-current
    @echo "🔍 Checking StarFive VisionFive 2 (RISC-V JH7110)..."
    nix eval .#visionfive2-vendor
    @echo "🔍 Running NixOS integration test..."
    nix eval --raw -f tests/test_nixos_module.nix
    @echo "🔍 Running Flake outputs integration test..."
    nix eval --raw -f tests/test_flake_outputs.nix
    @echo "✅ All key boards, integration tests, and formatting checks passed."
    pytest

# Drift guard: metadata/ is GENERATED (metadata/nix/library.nix = verbatim copy of the template).
# Checks that library.nix and firmware.nix still match the output of write_library_nix()
check-drift:
    python3 scripts/check_drift.py

# Kernel config gate without compilation — builds the .configfile only (no kernel compilation).
# Checks that the family's Armbian config is really applied — ex: just check-config orangepizero3-current
check-config board:
    python3 scripts/check_config.py {{board}}

# Same gate for every family/branch pair at once (one flake evaluation, ~3 s).
# One representative board per pair covers the 737 boards, since the kernel
# package is shared per family+branch — ex: just check-config-all
check-config-all:
    python3 scripts/check_all_configs.py

# L5 pruning gate — compares the full modules tree with the board's filtered tree
# (kept/removed list + weight). The kernel must already be built.
check-modules board:
    python3 scripts/check_modules.py {{board}}

# Hardware capabilities gate — decompiles the kernel DTB and requires the
# expected compatibles (cedrus VPU, HDMI). Fails if the platform patches are
# not applied, even when the kernel builds and Kconfig says "yes".
# Builds the kernel if needed — ex: just check-hw-caps orangepizero3-edge
check-hw-caps board:
    python3 scripts/check_hw_caps.py {{board}}

# Format all Python and Nix files in the repository
format:
    ruff format src/ tests/
    find . -name "*.nix" -not -path "*/.git/*" -not -path "*/templates/*" -exec nixfmt {} +

# Check formatting of Python and Nix files without modifying them
check-format:
    @echo "🔍 Checking Python and Nix code formatting..."
    ruff format --check src/ tests/
    find . -name "*.nix" -not -path "*/.git/*" -not -path "*/templates/*" -exec nixfmt --check {} +
    @echo "✅ Formatting is clean."


# Setup a local armbian-src for development and debugging
setup-dev:
    @if [ ! -d armbian-src ]; then \
        echo "Cloning Armbian source for development..."; \
        git clone --depth 1 https://github.com/armbian/build armbian-src; \
    else \
        echo "armbian-src already exists."; \
    fi

# Build the SD image of any example configuration (e.g. just build-example orangepizero3 orangepizero3)
build-example example config:
    nix build ./examples/{{example}}#nixosConfigurations.{{config}}.config.system.build.sdImage --allow-import-from-derivation --show-trace

# Build the firmware package for a specific board key (e.g. just build-firmware orangepizero3-edge)
build-firmware board:
    nix build .#{{board}} --allow-import-from-derivation --show-trace

# Build the U-Boot bootloader for a specific board key (e.g. just build-uboot orangepizero3-current)
build-uboot board:
    nix build .#uboot-{{board}} --allow-import-from-derivation --show-trace

# Build the Kernel for a specific board key (e.g. just build-kernel orangepizero3-current)
build-kernel board:
    nix build .#kernel-{{board}} --allow-import-from-derivation --show-trace
