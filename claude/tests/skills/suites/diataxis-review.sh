#!/usr/bin/env bash
# Tests the diataxis-review skill.
#
# - `reference.md`: a stray how-to sentence in a reference doc moves
#   into its own labeled section.
# - `ticket.md`: a ticket mixing explanation and how-to content gets
#   reorganized into labeled sections, one how-to per goal.
# - `chaos.md` and `notes.md`: a self-contradicting doc and a doc of
#   unsortable fragments are both left untouched.
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

SUITE_NAME=diataxis-review
SCRATCH_DIR="$(scratch_dir "$SUITE_NAME")"
fixtures="$here/fixtures/$SUITE_NAME"

setup() {
	printf "SETUP %s\n" "$(basename "${0%.sh}")"
	scratch_reset "$SCRATCH_DIR"
	cp "$fixtures"/*.md "$SCRATCH_DIR/"
}

invoke_claude() {
	for f in reference.md ticket.md chaos.md notes.md; do
		printf "TEST %s [%s]\n" "$(basename "${0%.sh}")" "$f"
		run_claude_cmd "$SCRATCH_DIR" "/diataxis-review $f" "$SCRATCH_DIR/logs/$f.log"
	done
}

check() {
	printf "CHECK %s\n" "$(basename "${0%.sh}")"
	[ -d "$SCRATCH_DIR" ] || {
		echo "no scratch dir at $SCRATCH_DIR, run '$0 setup' first"
		exit 1
	}

	assert_grep_re "reference doc: how-to section labeled" '^#+ .*how-to' "$SCRATCH_DIR/reference.md"
	assert_count "reference doc: stray moved, not copied or deleted" "tool --verbose --debug" 1 "$SCRATCH_DIR/reference.md"
	assert_count "ticket: one how-to section per goal" "How-to" 2 "$SCRATCH_DIR/ticket.md"
	assert_grep_re "ticket: explanation section labeled" '^#+ .*explanation' "$SCRATCH_DIR/ticket.md"
	assert_grep "ticket: root-cause content kept" "read side of" "$SCRATCH_DIR/ticket.md"
	assert_grep "ticket: workaround content kept" "byte on the read side" "$SCRATCH_DIR/ticket.md"
	assert_unchanged "chaos doc: left unedited" "$fixtures/chaos.md" "$SCRATCH_DIR/chaos.md"
	assert_unchanged "notes doc: left unedited" "$fixtures/notes.md" "$SCRATCH_DIR/notes.md"

	return "$fail"
}

run() {
	setup
	invoke_claude
	local status=0
	check || status=$?
	scratch_cleanup "$SCRATCH_DIR"
	return "$status"
}

main() {
	check_deps claude grep diff

	case "${1:-run}" in
	setup)
		setup
		printf '%s\n' \
			"Scratch dir: $SCRATCH_DIR" \
			"" \
			"In Claude Code, run:" \
			"  /diataxis-review $SCRATCH_DIR/reference.md" \
			"  /diataxis-review $SCRATCH_DIR/ticket.md" \
			"  /diataxis-review $SCRATCH_DIR/chaos.md" \
			"  /diataxis-review $SCRATCH_DIR/notes.md" \
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
