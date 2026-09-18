#!/usr/bin/env bash
set -euo pipefail

# Accepts a PR body with:
#   ## Summary
#   1-3 sentences + **Closes** [KEY](https://digital-bcg.atlassian.net/browse/KEY)
#   ## Changes
#   - bullet list
#   ## Test Plan
#   - [ ] checkboxes

if [[ -t 0 && $# -eq 0 ]]; then
  echo "Usage: pr-description.sh <<'EOF'
## Summary
...
EOF" >&2
  exit 1
fi

body="$(cat "${1:-/dev/stdin}")"
body="${body//$'\r'/}"

fail() {
  echo "$1" >&2
  exit 1
}

[[ -n "${body//[[:space:]]/}" ]] || fail "Description is empty"

extract_section() {
  local heading="$1"
  printf '%s\n' "$body" | awk -v h="$heading" '
    $0 == h { grab=1; next }
    /^## / { if (grab) exit }
    grab { print }
  '
}

headings="$(printf '%s\n' "$body" | grep -E '^## ' || true)"
[[ -n "$headings" ]] || fail "Missing headings: ## Summary, ## Changes, ## Test Plan"

printf '%s\n' "$headings" | grep -qx '## Summary' || fail "Missing ## Summary"
printf '%s\n' "$headings" | grep -qx '## Changes' || fail "Missing ## Changes"
printf '%s\n' "$headings" | grep -qx '## Test Plan' || fail "Missing ## Test Plan"

extra="$(printf '%s\n' "$headings" | grep -vxE '## (Summary|Changes|Test Plan)' || true)"
[[ -z "$extra" ]] || fail "Unexpected heading: ${extra%%$'\n'*}"

order="$(printf '%s\n' "$headings" | paste -sd ',' -)"
[[ "$order" == "## Summary,## Changes,## Test Plan" ]] || fail "Headings must be in order: ## Summary, ## Changes, ## Test Plan"

summary="$(extract_section '## Summary')"
changes="$(extract_section '## Changes')"
testplan="$(extract_section '## Test Plan')"

closes_re='\*\*Closes\*\* \[[A-Z]{2,}-[0-9]+\]\(https://digital-bcg\.atlassian\.net/browse/[A-Z]{2,}-[0-9]+\)'
closes_count="$(printf '%s\n' "$body" | grep -cE "$closes_re" || true)"
[[ "$closes_count" -eq 1 ]] || fail "Summary must include exactly one **Closes** [KEY](https://digital-bcg.atlassian.net/browse/KEY)"

printf '%s\n' "$summary" | grep -qE "$closes_re" || fail "**Closes** link must be in the Summary section"

closes_line="$(printf '%s\n' "$summary" | grep -E "$closes_re" | head -n1)"
key_text="$(printf '%s\n' "$closes_line" | sed -nE 's/.*\[([A-Z]{2,}-[0-9]+)\].*/\1/p')"
key_url="$(printf '%s\n' "$closes_line" | sed -nE 's#.*browse/([A-Z]{2,}-[0-9]+)\).*#\1#p')"
[[ "$key_text" == "$key_url" ]] || fail "Closes ticket key does not match URL (${key_text} vs ${key_url})"

prose="$(printf '%s\n' "$summary" | grep -vE "$closes_re" | sed '/^[[:space:]]*$/d' || true)"
[[ -n "$prose" ]] || fail "Summary must include 1-3 sentences before **Closes**"
printf '%s\n' "$prose" | grep -qi '1-3 sentences explaining' && fail "Replace the Summary placeholder with a real description"

sentence_ends="$(printf '%s' "$prose" | grep -oE '[.!?]' | wc -l | tr -d ' ')"
[[ "$sentence_ends" -ge 1 && "$sentence_ends" -le 3 ]] || fail "Summary must be 1-3 sentences"

change_bullets="$(printf '%s\n' "$changes" | grep -cE '^- [^[:space:]]' || true)"
[[ "$change_bullets" -ge 1 ]] || fail "Changes must include at least one bullet starting with '- '"
printf '%s\n' "$changes" | grep -qE '^- \[[ xX]\]' && fail "Changes bullets must not be checkboxes; use Test Plan for those"

test_checks="$(printf '%s\n' "$testplan" | grep -cE '^- \[ \]' || true)"
[[ "$test_checks" -ge 1 ]] || fail "Test Plan must include at least one unchecked checkbox: '- [ ] '"
