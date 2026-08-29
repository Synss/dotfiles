#!/usr/bin/env bash
# Tests for deny-git-if-colocated.pl. Run from anywhere; must execute inside
# this colocated jj/git repo for the bad-case tests to trigger.
set -euo pipefail

hook="$(dirname "$0")/deny-git-if-colocated.pl"
fail=0

payload() {
	jq -n --arg command "$1" '{tool_input: {command: $command}}'
}

assert_allowed() {
	local command=$1 label=$2
	out=$(payload "$command" | "$hook")
	if [ -n "$out" ]; then
		echo "FAIL $label: expected no output, got: $out"
		fail=1
	else
		echo "PASS $label"
	fi
}

assert_denied() {
	local command=$1 label=$2
	out=$(payload "$command" | "$hook")
	decision=$(jq -r '.hookSpecificOutput.permissionDecision // empty' <<<"$out")
	if [ "$decision" != "deny" ]; then
		echo "FAIL $label: expected permissionDecision=deny, got: $out"
		fail=1
	else
		echo "PASS $label"
	fi
}

assert_allowed 'git status' 'good case: git status allowed'
assert_denied 'git add asdf' 'bad case: git add denied'
assert_denied 'git -C /some/repo add asdf' '-C case: git -C ... add denied'
assert_denied 'git -c user.name=x commit' '-c case: git -c ... commit denied'

exit $fail
