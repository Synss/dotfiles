#!/usr/bin/env bash
# Tests the plain-review skill.
#
# `install.md` has a nominalization to rewrite; `safety.md` has both a
# nominalization to rewrite and a justified em dash that must survive.
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

SUITE_NAME=plain-review
SCRATCH_DIR="$(scratch_dir "$SUITE_NAME")"
fixtures="$here/fixtures/$SUITE_NAME"

setup() {
	scratch_reset "$SCRATCH_DIR"
	cp "$fixtures"/*.md "$SCRATCH_DIR/"

	printf '%s\n' \
		"Scratch dir: $SCRATCH_DIR" \
		"" \
		"In Claude Code, run:" \
		"  /plain-review $SCRATCH_DIR/install.md" \
		"  /plain-review $SCRATCH_DIR/safety.md" \
		"" \
		"Then: $0 check"
}

check() {
	[ -d "$SCRATCH_DIR" ] || {
		echo "no scratch dir at $SCRATCH_DIR, run '$0 setup' first"
		exit 1
	}

	assert_grep "justified em dash kept" "— not even on first run" "$SCRATCH_DIR/safety.md"
	assert_no_grep "nominalization rewritten (safety)" "Utilization" "$SCRATCH_DIR/safety.md"
	assert_no_grep "nominalization rewritten (install)" "Installation of" "$SCRATCH_DIR/install.md"
	assert_no_grep "two-idea semicolon split (install)" ";" "$SCRATCH_DIR/install.md"

	return "$fail"
}

run() {
	setup >/dev/null
	for f in install.md safety.md; do
		run_claude_cmd "$SCRATCH_DIR" "/plain-review $f" "$SCRATCH_DIR/logs/$f.log"
	done
	local status=0
	check || status=$?
	scratch_cleanup "$SCRATCH_DIR"
	return "$status"
}

main() {
	check_deps

	case "${1:-run}" in
	setup | check | run) "$1" ;;
	*)
		echo "usage: $0 setup|check|run"
		exit 2
		;;
	esac
}

main "$@"
