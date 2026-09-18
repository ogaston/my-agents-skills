#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
title="${1-}"

if [[ -z "$title" || -t 0 ]]; then
  echo "Usage: pr-create.sh \"<ticket-key>: <short description>\" <<'EOF'
## Summary
...
EOF" >&2
  exit 1
fi

body="$(cat)"
body="${body//$'\r'/}"

bash "$script_dir/pr-title.sh" "$title"
printf '%s\n' "$body" | bash "$script_dir/pr-description.sh"

git push -u origin HEAD --quiet
gh pr create --title "$title" --body "$body"
