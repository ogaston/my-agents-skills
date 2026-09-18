#!/usr/bin/env bash
set -euo pipefail

branch="$(git rev-parse --abbrev-ref HEAD)"

case "$branch" in
  main|master|dev|develop)
    git status --short
    git diff --stat HEAD
    git log --oneline -5
    echo "not ready: ${branch}" >&2
    exit 1
    ;;
esac

printf '%s\n' "$branch"
