#!/usr/bin/env bash
# Dispatches a fresh reviewer against fixtures/seeded-violations.md and greps
# its raw text output for the expected rule statuses and a few seeded
# sentences -- the same assert_contains style as the superpowers plugin's
# tests/claude-code/test-helpers.sh (github:obra/superpowers). No
# structured parsing, no ground-truth JSON, no second judge call. Costs a
# real API call per run, so it isn't wired into a hook -- run it by hand
# after changing SKILL.md.
#
# No total-instance-count check: rule 3's table sentence trips two global
# constraints, and across live runs the model reliably cites each one
# individually but not always both together in the same run -- a recall
# gap, not a format bug (see tests/README.md).
set -euo pipefail
cd "$(dirname "$0")"

FIXTURE="fixtures/seeded-violations.md"
TIMEOUT="${TIMEOUT:-120}"
failures=0

dump_output() {
  echo "    Output:"
  printf '      %s\n' "${output//$'\n'/$'\n      '}"
}

assert_contains() {
  local pattern="$1" label="$2"
  if grep -qi "$pattern" <<<"$output"; then
    echo "  [PASS] $label"
  else
    echo "  [FAIL] $label"
    echo "    Expected to find: $pattern"
    dump_output
    failures=$((failures + 1))
  fi
}

echo "==> Dispatching fresh reviewer against $FIXTURE"
output=$(timeout "$TIMEOUT" claude -p "Use the reviewing-claude-md skill to review \`$FIXTURE\`." \
  --no-session-persistence \
  --allowedTools Skill Read)

echo "==> Checking output"
for n in 1 2 3 4 5 6 7; do
  assert_contains "Rule $n —.*triggered" "Rule $n triggered"
done

# Confirms the right violation was found, not just any triggered status.
assert_contains "always explain why I changed the page" "Rule 3/4 instance quotes the seeded sentence"
assert_contains "rendered table listing every page" "Rule 3's second instance quotes the table sentence"
assert_contains "Retries back off exponentially" "Rule 5 instance quotes the seeded backoff sentence"

echo ""
if [ "$failures" -gt 0 ]; then
  echo "STATUS: FAILED ($failures failures)"
  exit 1
fi
echo "STATUS: PASSED"
