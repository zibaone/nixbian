# Security

## Supported versions

Nixbian is experimental. Only the latest published release (0.3.x) receives
security fixes.

## Reporting a vulnerability

**Do not open a public issue.** Use the **Security → Report a vulnerability**
tab of the GitHub repository:

<https://github.com/zibaone/nixbian/security/advisories/new>

If the tab is not available, contact the maintainer (`@zibaone`) privately on
GitHub.

Please include:

- the affected version (`pyproject.toml` / tag);
- reproduction steps;
- the estimated impact (code execution, path leak, metadata corruption,
  supply chain);
- a minimal proof of concept if possible.

## Scope

In scope:

- the Python generator (`src/armbian_extractor/`);
- the Nix expressions and the NixOS module (`nix/`, `metadata/nix/`);
- the CI workflows and hash-resolution scripts;
- vendored patches (provenance, integrity, file names).

**Not** covered by this repository: vulnerabilities in the Linux kernel, U-Boot,
ATF or Armbian itself. Report those to their upstream projects.

## Good practices

- Never commit a secret, token or personal path.
- Workflows only use `GITHUB_TOKEN` with minimal permissions.
- External contributions go through a PR and the CI gates.
