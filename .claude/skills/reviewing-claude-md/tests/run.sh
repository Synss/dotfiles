#!/usr/bin/env bash
# Dispatches a fresh reviewer against each fixture and greps its raw text
# output for the expected rule statuses and a few seeded sentences -- the
# same assert_contains style as the superpowers plugin's
# tests/claude-code/test-helpers.sh (github:obra/superpowers). No
# structured parsing, no ground-truth JSON, no second judge call. Costs
# two real API calls per run, so it isn't wired into a hook -- run it by
# hand after changing SKILL.md.
#
# No total-instance-count check: global-interaction's table sentence trips
# two global constraints, and across live runs the model reliably cites
# each one individually but not always both together in the same run -- a
# recall gap, not a format bug (see tests/README.md).
set -euo pipefail
cd "$(dirname "$0")"

TIMEOUT="${TIMEOUT:-180}"
failures=0
RULES=(no-restatement concrete-thresholds global-interaction pronoun-convention topic-grouping bullet-vs-sequence xml-tagging-justified)

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

assert_not_contains() {
  local pattern="$1" label="$2"
  if grep -qi "$pattern" <<<"$output"; then
    echo "  [FAIL] $label"
    echo "    Expected NOT to find: $pattern"
    dump_output
    failures=$((failures + 1))
  else
    echo "  [PASS] $label"
  fi
}

dispatch() {
  local fixture="$1"
  echo "==> Dispatching fresh reviewer against $fixture"
  timeout "$TIMEOUT" claude -p "Use the reviewing-claude-md skill to review \`$fixture\`." \
    --no-session-persistence \
    --allowedTools Skill Read
}

# Recall: fixtures/seeded-violations.md seeds one violation per rule --
# every rule must fire.
output=$(dispatch fixtures/seeded-violations.md)

echo "==> Checking output (recall)"
for slug in "${RULES[@]}"; do
  assert_contains "Rule $slug —.*triggered" "Rule $slug triggered"
done

# Confirms the right violation was found, not just any triggered status.
assert_contains "always explain why I changed the page" "global-interaction/pronoun-convention instance quotes the seeded sentence"
assert_contains "rendered table listing every page" "global-interaction's second instance quotes the table sentence"
assert_contains "Retries back off exponentially" "topic-grouping instance quotes the seeded backoff sentence"

# Precision: fixtures/clean.md has one near-miss per rule that must NOT
# fire -- see tests/expected-findings-clean.md.
output=$(dispatch fixtures/clean.md)

echo "==> Checking output (precision)"
assert_not_contains "— triggered" "clean.md: no rule reports triggered"
for slug in "${RULES[@]}"; do
  assert_contains "Rule $slug —.*left_alone" "Rule $slug left_alone"
done

echo ""
if [ "$failures" -gt 0 ]; then
  echo "STATUS: FAILED ($failures failures)"
  exit 1
fi
echo "STATUS: PASSED"
