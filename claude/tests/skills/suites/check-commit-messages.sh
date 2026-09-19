#!/usr/bin/env bash
# Tests the check-commit-messages skill.
#
# Builds a throwaway jj repo with three commits: a clean initial commit,
# a commit whose subject and body are fine as-is, and a commit whose
# body has a semicolon joining two ideas that the skill must split.
set -euo pipefail

here="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=claude/tests/skills/lib/deps.sh
source "$here/lib/deps.sh"
# shellcheck source=claude/tests/skills/lib/scratch.sh
source "$here/lib/scratch.sh"
# shellcheck source=claude/tests/skills/lib/assertions.sh
source "$here/lib/assertions.sh"
# shellcheck source=claude/tests/skills/lib/claude.sh
source "$here/lib/claude.sh"

SUITE_NAME=check-commit-messages
SCRATCH_DIR="$(scratch_dir "$SUITE_NAME")"
fixtures="$here/fixtures/$SUITE_NAME"
repo="$SCRATCH_DIR/repo"
awk_check="$here/../../skills/check-commit-messages/scripts/check.awk"

revset() {
	echo "$(cat "$SCRATCH_DIR/config-rev") | $(cat "$SCRATCH_DIR/retry-rev")"
}

setup() {
	printf "SETUP %s\n" "$(basename "${0%.sh}")"
	scratch_reset "$SCRATCH_DIR"
	mkdir -p "$repo/.claude"
	cp "$fixtures/CLAUDE.md" "$repo/.claude/CLAUDE.md"

	(
		cd "$repo"
		jj git init . >/dev/null 2>&1

		cp "$fixtures/initial/config.py" "$fixtures/initial/net.py" .
		jj commit -m "$(cat "$fixtures/initial/message.txt")" >/dev/null 2>&1

		cp "$fixtures/config-change/config.py" .
		jj commit -m "$(cat "$fixtures/config-change/message.txt")" >/dev/null 2>&1

		cp "$fixtures/retry-connect/net.py" .
		jj commit -m "$(cat "$fixtures/retry-connect/message.txt")" >/dev/null 2>&1

		jj log -r '@-' --no-graph -T 'change_id.short()' >"$SCRATCH_DIR/retry-rev"
		jj log -r '@--' --no-graph -T 'change_id.short()' >"$SCRATCH_DIR/config-rev"
	)
}

check() {
	printf "CHECK %s\n" "$(basename "${0%.sh}")"
	[ -d "$SCRATCH_DIR" ] || {
		echo "no scratch dir at $SCRATCH_DIR, run '$0 setup' first"
		exit 1
	}

	local retry_rev config_rev revset desc out
	retry_rev=$(cat "$SCRATCH_DIR/retry-rev")
	config_rev=$(cat "$SCRATCH_DIR/config-rev")
	assert_nonempty "retry revision captured" "$retry_rev"
	assert_nonempty "config revision captured" "$config_rev"

	revset=$(revset)
	desc=$(cd "$repo" && jj log -r "$retry_rev" --no-graph -T description)
	if grep -qF ';' <<<"$desc"; then
		echo "FAIL two-idea semicolon split (commit): $desc"
		fail_context
		fail=1
	else
		echo "PASS two-idea semicolon split (commit)"
	fi

	out=$(cd "$repo" && jj log -r "$revset" --no-graph \
		-T 'commit_id.short() ++ "\x01" ++ description ++ "\x02"' |
		awk -v limit=50 -v prefix_re='^[a-z*]+: ' -f "$awk_check" |
		grep -v '^COMMIT ' || true)
	if [ -n "$out" ]; then
		echo "FAIL awk check clean: $out"
		fail_context
		fail=1
	else
		echo "PASS awk check clean"
	fi

	return "$fail"
}

run() {
	setup
	local revset
	revset=$(revset)
	run_claude_cmd "$repo" "/check-commit-messages $revset" "$SCRATCH_DIR/logs/check-commit-messages.log"
	local status=0
	check || status=$?
	scratch_cleanup "$SCRATCH_DIR"
	return "$status"
}

main() {
	check_deps

	case "${1:-run}" in
	setup)
		setup
		local revset
		revset=$(revset)
		printf '%s\n' \
			"Scratch dir: $SCRATCH_DIR" \
			"" \
			"In Claude Code, from $repo, run:" \
			"  /check-commit-messages $revset" \
			"" \
			"Then: $0 check"
		;;
	check | run) "$1" ;;
	*)
		echo "usage: $0 setup|check|run"
		exit 2
		;;
	esac
}

main "$@"
