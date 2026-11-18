#!/usr/bin/env bash
# Prints a merge request's threads, one JSON object each (see threads.jq). Run it in the checkout:
#   .agents/skills/review-mr-feedback/threads.sh <MR>
set -euo pipefail
# Without it, a failed user lookup inside $(...) is ignored unless it is the last one.
shopt -s inherit_errexit
filter="$(cd "$(dirname "$0")" && pwd)/threads.jq"
cd "$(git rev-parse --show-toplevel)"

notes=$(bin/glab mr note list "$1" -F json)
me=$(bin/glab api user | jq .id)

# Notes show bots' names as "****" and do not say who is a bot; the users API has both.
users=$(
  jq -r '[.[].notes[] | select(.system | not) | .author.id] | unique[]' <<< "$notes" \
    | while read -r id; do bin/glab api "users/$id" | jq '{key: (.id | tostring), value: {name, bot}}'; done \
    | jq -s from_entries
)

jq --argjson me "$me" --argjson users "$users" -f "$filter" <<< "$notes"
