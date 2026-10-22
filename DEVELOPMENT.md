# Nixbian Development & AI Agent Guide

Welcome! This repository uses a hybrid Python/Nix metadata extraction pipeline to build NixOS images for various ARM/RISC-V/x86 single-board computers (SBCs).

This document outlines the architecture, developer rules, and command workflows to guide both human developers and AI agents.

---

## 🚨 CRITICAL RULE: DO NOT MANUALLY EDIT GENERATED FILES

A significant portion of the Nix codebase is auto-generated from Armbian's build configuration inventories. 

* **NEVER** manually edit files inside the following directories:
  * `metadata/board_metadata.json`
  * `metadata/nix/` (e.g., `metadata/nix/families/*`, `metadata/nix/library.nix`, etc.)
  * `metadata/nvfetcher.sources.toml` / `metadata/nvfetcher.lock.toml`
  * `metadata/sources/` (e.g., `metadata/sources/generated.nix`)
* **Why?** Any manual edits to these files will be overwritten the next time the extraction generator runs.
* **How to make changes instead:**
  * To change generated Nix layout/logic, edit the templates under `src/armbian_extractor/templates/` (like `library.nix`, `firmware.nix`, etc.) or modify the Python emitter in `src/armbian_extractor/generator.py`.
  * After editing, run the regeneration command `just refresh-metadata`.

---

## 📂 Repository Architecture

```
nixbian/
├── Justfile                      # Command runner (just refresh-metadata, just check, etc.)
├── versions.json                 # Tracks current Armbian versions and tags
├── src/                          # Extraction & Generator Source Code (Python)
│   └── armbian_extractor/
│       ├── cli.py                # Command line interface
│       ├── generator.py          # Generates Nix files from metadata
│       ├── nvgen.py              # Generates nvfetcher configurations
│       └── templates/            # Base Nix templates copied/hydrated during extraction
├── nix/                          # Hand-written core Nix modules and flake parts
│   └── parts/
│       └── packages.nix          # Exposes package outputs and cross-compilation mapping
├── metadata/                     # AUTO-GENERATED OUTPUTS (Do not edit directly)
│   ├── board_metadata.json       # Extracted JSON raw info
│   ├── nvfetcher.sources.toml    # Auto-generated source definitions
│   ├── nvfetcher.lock.toml       # Resolved source revisions and hashes
│   ├── sources/                  # Hashes resolved by nvfetcher
│   └── nix/                      # Nix representations of boards and platforms
│       ├── families/             # Sub-folders containing platform/board definitions
│       └── library.nix           # Hydrated helpers (buildKernel, buildUBoot, etc.)
└── examples/                     # Consumer examples for testing board builds
    └── orangepizero3/            # Orange Pi Zero 3 target image definition
```

---

## ⚙️ Core Developer Commands

Always run these commands inside the Nix environment (`nix develop --command just <cmd>` or within `nix develop` shell).

### 1. Re-run Extraction and Codegen
If you modify Python code in `src/` or files in `src/armbian_extractor/templates/`, run:
```bash
just refresh-metadata
```
This builds the extraction derivation inside a Nix sandbox, runs the Python code to re-extract inventories, copies the generated expressions into `metadata/nix/`, and runs tests.

### 2. Lock Source Hashes (`nvfetcher`)
If kernel branches, U-Boot branches, or repositories change, update their cryptographic hashes:
* **For all boards:**
  ```bash
  just fetch-hashes
  ```
* **For a single board only (much faster):**
  ```bash
  just fetch-board <board-name>
  ```

### 3. Check Configurations and Run Tests
Validate evaluation of key targets and run Python unit tests:
```bash
just check
```

---

## 🔗 How Hash Injection Works

1. **Extraction**: `src/armbian_extractor/nvgen.py` resolves the git repositories and branches from Armbian. It adds a deterministic key field called `nvfetcher_key` (and `atf_nvfetcher_key` for Arm Trusted Firmware) directly into the platform/board metadata.
2. **Locking**: `nvfetcher` fetches the upstream git revisions and generates output hashes, saving them to `metadata/sources/generated.nix`.
3. **Nix Resolution**: The Nix hardware module loads the generated metadata and references `sources.${nvfetcher_key}` to inject the exact locked derivation source (`src`) directly into build helpers (`buildKernel`, `buildUBoot`, etc.).
