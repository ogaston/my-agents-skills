#!/usr/bin/env bash
set -euo pipefail

base="${1:-main}"

git fetch origin --quiet
git rebase --quiet "origin/${base}"
