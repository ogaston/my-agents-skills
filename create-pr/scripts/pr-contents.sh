#!/usr/bin/env bash
set -euo pipefail

base="${1:-main}"

git log "origin/${base}..HEAD" --oneline
git diff "origin/${base}" --stat
