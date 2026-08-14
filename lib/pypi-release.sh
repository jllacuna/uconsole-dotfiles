#!/usr/bin/env bash
#
# Shared helper for run_ scripts that install software from PyPI via uv.
#
# Determines the latest package version before the cooldown period
# Designed to avoid supply chain hacks
#
# jq is the sole dependency and must be installed before any script uses it

COOLDOWN_DAYS=${RELEASE_COOLDOWN_DAYS:-7}

# Usage: pypi_package_version PACKAGE_NAME
#
# Prints the newest non-yanked, non-prerelease version of PACKAGE_NAME published on PyPI at least COOLDOWN_DAYS ago
# Prints nothing if none qualify
pypi_package_version() {
  local package=$1
  local cutoff
  cutoff=$(date -u -d "${COOLDOWN_DAYS} days ago" +%Y-%m-%dT%H:%M:%S)

  curl -s "https://pypi.org/pypi/$package/json" | jq -r --arg cutoff "$cutoff" '
    .releases
    | to_entries
    | map(select(.value | length > 0))
    | map({
        version: .key,
        yanked: (.value | any(.yanked)),
        uploaded: (.value | map(.upload_time) | max)
      })
    | map(select(
        .yanked == false
        and .uploaded <= $cutoff
        and (.version | test("dev|alpha|beta|preview|[0-9](a|b|c|rc)[0-9]"; "i") | not)
      ))
    | sort_by(.uploaded)
    | last
    | .version // empty
  '
}
