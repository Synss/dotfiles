#!/bin/sh
set -eu

PLAYBOOK="${1:-site.yml}"

cd "$(dirname "$0")"

echo "First run" >&2
uv run ansible-playbook "$PLAYBOOK" >/dev/null 2>&1

echo "Second run" >&2
output=$(
    ANSIBLE_DEPRECATION_WARNINGS=false \
    ANSIBLE_STDOUT_CALLBACK=json \
    uv run ansible-playbook "$PLAYBOOK"
)

if echo "$output" | jq -e '[.stats | to_entries[].value.changed] | all(. == 0)' > /dev/null; then
    echo "PASS: idempotent"
else
    echo "FAIL: not idempotent — changed tasks:" >&2
    echo "$output" | jq -r '
      .plays[].tasks[] |
      . as $t |
      .hosts | to_entries[] |
      select(.value.changed == true) |
      "\(.key): \($t.task.name)"
    ' >&2
    exit 1
fi
