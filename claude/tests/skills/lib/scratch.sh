#!/usr/bin/env bash
# Scratch directory conventions shared by every suite.
#
# SKILL_TEST_ROOT overrides the root all suites scratch under; each suite
# gets its own subdirectory so suites never share state.
# KEEP_SKILL_TEST_DIR=1 skips the cleanup that scratch_cleanup() would
# otherwise do at the end of a `run`, so the directory survives for
# debugging.

skill_test_root() {
	echo "${SKILL_TEST_ROOT:-${TMPDIR:-/tmp}/claude-skill-tests}"
}

# Prints the scratch directory for the given suite name.
scratch_dir() {
	echo "$(skill_test_root)/$1"
}

# Wipes and recreates the suite's scratch directory.
scratch_reset() {
	local dir=$1
	rm -rf "$dir"
	mkdir -p "$dir"
}

# Removes the suite's scratch directory unless KEEP_SKILL_TEST_DIR is set.
scratch_cleanup() {
	local dir=$1
	if [ -n "${KEEP_SKILL_TEST_DIR:-}" ]; then
		echo "keeping scratch dir for debugging: $dir"
	else
		rm -rf "$dir"
	fi
}
