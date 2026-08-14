# lib

Shared helper libraries, `source`d by `.chezmoiscripts`. Supports implementation of a 7-day "cooldown" when installing software to avoid supply chain hacks.

- Not under `home/`, so chezmoi never deploys anything here as a dotfile.
- Source via env var (e.g. `$CHEZMOI_WORKING_TREE/lib/*.sh`) or with template variable `.chezmoi.workingTree` in `.tmpl` files.
- The cooldown period can be set with env var `RELEASE_COOLDOWN_DAYS` (defaults to 7).
- `jq` is the one hard dependency across both files, and must already be installed before any script sources them.

## `github-release.sh`

Cooldown-gated version resolution against the GitHub API, for tools distributed via GitHub.

- `cooldown_cutoff`: Prints the RFC3339 UTC timestamp `COOLDOWN_DAYS` ago. Shared by the two functions below, or used directly.
- `github_release_tag OWNER/REPO`: For repos that publish GitHub Releases. Prints the newest non-draft, non-prerelease release tag published at least `COOLDOWN_DAYS` ago.
- `github_commit_before OWNER/REPO BRANCH`: For repos with no releases at all. Prints the sha of the newest commit on `BRANCH` at least `COOLDOWN_DAYS` old.
- `github_tag_before OWNER/REPO`: For repos with tags but no releases. Prints the newest tag at least `COOLDOWN_DAYS` ago.

> [!TIP]
> Add an optional GitHub personal access token if running into GitHub API rate limits.
> see [GitHub API rate limits](../README.md#github-api-rate-limits).

## `cargo-release.sh`

Cooldown-gated version resolution for rust crates.

- `cargo_crate_version CRATE_NAME`: Prints the newest non-yanked version published on crates.io at least `COOLDOWN_DAYS` ago.

## `pypi-release.sh`

Cooldown-gated version resolution for PyPI packages, for tools installed via `uv tool`.

- `pypi_package_version PACKAGE_NAME`: Prints the newest non-yanked, non-prerelease version published on PyPI at least `COOLDOWN_DAYS` ago.
