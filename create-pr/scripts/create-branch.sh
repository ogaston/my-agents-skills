#!/usr/bin/env bash
set -euo pipefail

type="${1-}"
key="${2-}"
slug="${3-}"

usage() {
  echo "Usage: create-branch.sh <type> <ticket-key> [slug]" >&2
  echo "Types: feat fix chore docs refactor test perf ci build style" >&2
  echo "e.g. create-branch.sh feat AWS-001 add-dark-mode" >&2
  exit 1
}

[[ -n "$type" && -n "$key" ]] || usage

case "$type" in
  feat|fix|chore|docs|refactor|test|perf|ci|build|style) ;;
  *)
    echo "Unknown type '${type}'. Use: feat fix chore docs refactor test perf ci build style" >&2
    exit 1
    ;;
esac

if [[ ! "$key" =~ ^[A-Z]{2,}-[0-9]+$ ]]; then
  echo "Ticket key must look like AWS-001" >&2
  exit 1
fi

if [[ -n "$slug" ]]; then
  slug="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
  branch="${type}/${key}-${slug}"
else
  branch="${type}/${key}"
fi

git checkout -q -b "$branch"
printf '%s\n' "$branch"
