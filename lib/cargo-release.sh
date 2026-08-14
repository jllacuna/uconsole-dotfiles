#!/usr/bin/env bash
#
# Shared helper for run_ scripts that install software from crates.io via cargo.
#
# Determines the latest crate version before the cooldown period
# Designed to avoid supply chain hacks
#
# jq is the sole dependency and must be installed before any script uses it

COOLDOWN_DAYS=${RELEASE_COOLDOWN_DAYS:-7}

# Usage: cargo_crate_version CRATE_NAME
#
# Prints the newest non-yanked version of CRATE_NAME published on crates.io at least COOLDOWN_DAYS ago
# Prints nothing if none qualify
cargo_crate_version() {
  local crate=$1
  local cutoff
  cutoff=$(date -u -d "${COOLDOWN_DAYS} days ago" +%Y-%m-%dT%H:%M:%SZ)

  curl -s -H "User-Agent: chezmoi-cooldown" "https://crates.io/api/v1/crates/$crate/versions" | jq -r --arg cutoff "$cutoff" '
    .versions
    | map(select(.yanked == false and .created_at <= $cutoff))
    | sort_by(.created_at)
    | last
    | .num // empty
  '
}
