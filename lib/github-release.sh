#!/usr/bin/env bash
#
# Shared helper for run_ scripts that install software from GitHub.
#
# Determines the latest release before the cooldown period
# Designed to avoid supply chain hacks
#
# jq is the sole dependency and must be installed before any script uses it

COOLDOWN_DAYS=${RELEASE_COOLDOWN_DAYS:-7}

# Optional GitHub personal access token for increased rate limits (see README.md)
_GH_TOKEN_FILE="$CHEZMOI_WORKING_TREE/lib/github-token.age"

_GH_TOKEN=""
[ -f "$_GH_TOKEN_FILE" ] && _GH_TOKEN=$(chezmoi decrypt "$_GH_TOKEN_FILE" 2> /dev/null)

# Usage: _gh_curl URL
#
# curl wrapper that attaches the optional GitHub token, if one was loaded above
_gh_curl() {
  if [ -n "$_GH_TOKEN" ]; then
    curl -s -H "Authorization: Bearer $_GH_TOKEN" "$@"
  else
    curl -s "$@"
  fi
}

# Usage: _gh_check_error OWNER/REPO RESPONSE
#
# Checks for GitHub API error responses (e.g. rate limiting, not found, bad credentials)
# Prints an identifying message to stderr and returns 1 if RESPONSE is an error.
_gh_check_error() {
  local slug=$1 response=$2 message
  message=$(jq -r 'if type == "object" then .message // empty else empty end' <<< "$response" 2> /dev/null)
  if [ -n "$message" ]; then
    echo "github-release.sh: GitHub API error for $slug, try again later: $message" >&2
    return 1
  fi
  return 0
}

# Usage: cooldown_cutoff
#
# Prints the ISO-8601 UTC timestamp COOLDOWN_DAYS ago
cooldown_cutoff() {
  date -u -d "${COOLDOWN_DAYS} days ago" +%Y-%m-%dT%H:%M:%SZ
}

# Usage: github_release_tag OWNER/REPO
#
# Prints the tag_name of the newest stable (non-draft, non-prerelease) release published at least COOLDOWN_DAYS ago
# Prints nothing if none qualify, or if the GitHub API call fails (e.g. rate limited)
# Fetches up to 100 releases (GitHub's max page size, unpaginated) - without this,
# a repo that releases more often than ~30 times within COOLDOWN_DAYS (e.g.
# mason-org/mason-registry, which releases multiple times a day) would never see
# a release old enough on the default 30-result page and silently return nothing
github_release_tag() {
  local slug=$1
  local cutoff response
  cutoff=$(cooldown_cutoff)

  response=$(_gh_curl "https://api.github.com/repos/$slug/releases?per_page=100")
  _gh_check_error "$slug" "$response" || return 1

  jq -r --arg cutoff "$cutoff" '
    map(select(.draft == false and .prerelease == false and .published_at <= $cutoff))
    | sort_by(.published_at)
    | last
    | .tag_name // empty
  ' <<< "$response"
}

# Usage: github_commit_before OWNER/REPO BRANCH
#
# For repos with no releases (e.g. plain zsh plugins), prints the sha of the newest commit on BRANCH at least COOLDOWN_DAYS old
# Prints nothing if none qualify, or if the GitHub API call fails (e.g. rate limited)
github_commit_before() {
  local slug=$1 branch=$2
  local cutoff response
  cutoff=$(cooldown_cutoff)

  response=$(_gh_curl "https://api.github.com/repos/$slug/commits?sha=$branch&until=$cutoff&per_page=1")
  _gh_check_error "$slug" "$response" || return 1

  jq -r '.[0].sha // empty' <<< "$response"
}

# Usage: github_tag_before OWNER/REPO
#
# For repos with tags but no releases (e.g. rustup), prints the newest tag whose underlying commit is at least COOLDOWN_DAYS old
# Relies on the tags API returning tags newest-first, true for a linear release history
# Prints nothing if none qualify, or if any GitHub API call fails (e.g. rate limited)
github_tag_before() {
  local slug=$1
  local cutoff tags_response
  cutoff=$(date -u -d "${COOLDOWN_DAYS} days ago" +%s)

  tags_response=$(_gh_curl "https://api.github.com/repos/$slug/tags?per_page=30")
  _gh_check_error "$slug" "$tags_response" || return 1

  local name sha commit_response commit_date commit_epoch
  while read -r name sha; do
    commit_response=$(_gh_curl "https://api.github.com/repos/$slug/commits/$sha")
    _gh_check_error "$slug" "$commit_response" || return 1
    commit_date=$(jq -r '.commit.committer.date // empty' <<< "$commit_response")
    [ -z "$commit_date" ] && continue
    commit_epoch=$(date -u -d "$commit_date" +%s)
    if [ "$commit_epoch" -le "$cutoff" ]; then
      echo "$name"
      return 0
    fi
  done < <(jq -r '.[] | "\(.name) \(.commit.sha)"' <<< "$tags_response")
}
