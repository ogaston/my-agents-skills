#!/usr/bin/env bash
set -euo pipefail

# Accepts: <ticket-key>: <short description>
# e.g. AWS-001: add dark mode toggle to settings page
#      GAP-18: prevent duplicate form submissions on checkout
#      AZ-471: extract auth middleware into shared module

title="${1-}"

if [[ -z "$title" ]]; then
  echo "Usage: pr-title.sh \"<ticket-key>: <short description>\"" >&2
  exit 1
fi

if [[ "$title" =~ [[:space:]]$ || "$title" =~ ^[[:space:]] ]]; then
  echo "Title has leading or trailing whitespace" >&2
  exit 1
fi

if [[ ! "$title" =~ ^[A-Z]{2,}-[0-9]+:\ .+$ ]]; then
  echo "Expected '<TICKET-KEY>: <short description>' (e.g. AWS-001: add dark mode toggle to settings page)" >&2
  exit 1
fi

desc="${title#*: }"

if [[ "$desc" =~ ^[[:space:]] || "$desc" =~ [[:space:]]{2,} ]]; then
  echo "Use exactly one space after the colon, and no double spaces" >&2
  exit 1
fi

if [[ "$desc" == *. ]]; then
  echo "Description must not end with a period" >&2
  exit 1
fi

if [[ ! "$desc" =~ ^[a-z] ]]; then
  echo "Description must start with a lowercase letter" >&2
  exit 1
fi

if [[ "$desc" =~ [A-Z] ]]; then
  echo "Description must be lowercase" >&2
  exit 1
fi
