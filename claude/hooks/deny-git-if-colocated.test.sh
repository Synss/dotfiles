#!/usr/bin/env bash
# Tests for deny-git-if-colocated.pl. Run from anywhere; must execute inside
# this colocated jj/git repo for the bad-case test to trigger.
set -euo pipefail

hook="$(dirname "$0")/deny-git-if-colocated.pl"
fail=0

payload() {
	jq -n --arg command "$1" '{tool_input: {command: $command}}'
}

# Good case: a non-mutating git command is allowed (no output, exit 0).
out=$(payload 'git status' | "$hook")
if [ -n "$out" ]; then
	echo "FAIL good case: expected no output, got: $out"
	fail=1
else
	echo "PASS good case: git status allowed"
fi

# Bad case: a mutating git command in a colocated repo is denied.
out=$(payload 'git add asdf' | "$hook")
decision=$(jq -r '.hookSpecificOutput.permissionDecision // empty' <<<"$out")
if [ "$decision" != "deny" ]; then
	echo "FAIL bad case: expected permissionDecision=deny, got: $out"
	fail=1
else
	echo "PASS bad case: git add denied"
fi

# Bad case: a mutating git command behind a -C global option is still denied.
out=$(payload 'git -C /some/repo add asdf' | "$hook")
decision=$(jq -r '.hookSpecificOutput.permissionDecision // empty' <<<"$out")
if [ "$decision" != "deny" ]; then
	echo "FAIL -C case: expected permissionDecision=deny, got: $out"
	fail=1
else
	echo "PASS -C case: git -C ... add denied"
fi

# Bad case: a mutating git command behind a -c global option is still denied.
out=$(payload 'git -c user.name=x commit' | "$hook")
decision=$(jq -r '.hookSpecificOutput.permissionDecision // empty' <<<"$out")
if [ "$decision" != "deny" ]; then
	echo "FAIL -c case: expected permissionDecision=deny, got: $out"
	fail=1
else
	echo "PASS -c case: git -c ... commit denied"
fi

exit $fail
