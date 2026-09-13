#!/usr/bin/env bash
# Tests for the plain-review and check-commit-messages skills.
#
# The skills are user-invoked only, so the review step needs a Claude
# Code session. Two ways to run:
#
#   run.sh setup   build the scratch dir and print the slash commands
#   (review by hand in Claude Code)
#   run.sh check   assert the expected outcome
#
#   run.sh run     setup, review through `claude -p`, then check
#
# What the fixtures test: a justified em dash must survive, a semicolon
# joining two ideas must go, and nominalized passive sentences must be
# rewritten. Sentence-level checks are loose on purpose: the skills are
# judged on outcome, not on exact wording.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
dir="${SKILL_TEST_DIR:-${TMPDIR:-/tmp}/claude-skill-tests}"
repo="$dir/repo"
awk_check="$here/../../skills/check-commit-messages/scripts/check.awk"
fail=0

revset() {
	echo "$(cat "$dir/config-rev") | $(cat "$dir/retry-rev")"
}

setup() {
	rm -rf "$dir"
	mkdir -p "$dir/prose" "$repo/.claude"
	cp "$here"/fixtures/*.md "$dir/prose/"

	cat >"$repo/.claude/CLAUDE.md" <<-'MD'
		# Test project

		## Commit messages

		Subject: prefixed with a lowercase component and a colon, here
		always `tool:`. The prefix does not count toward the global ~50
		character limit. The first word after the prefix is capitalized.
	MD

	(
		cd "$repo"
		jj git init . >/dev/null 2>&1
		cat >config.py <<-'PY'
			PATHS = ["~/.tool.conf", "/etc/tool.conf"]


			def load():
			    for p in PATHS:
			        if exists(p):
			            return read(p)
		PY
		cat >net.py <<-'PY'
			def connect(sock, addr):
			    sock.connect(addr)
		PY
		jj commit -m "tool: Initial layout" >/dev/null 2>&1

		cat >config.py <<-'PY'
			# The system file must win over the user file, matching every other
			# tool shipped on the box.
			PATHS = ["/etc/tool.conf", "~/.tool.conf"]


			def load():
			    for p in PATHS:
			        if exists(p):
			            return read(p)
		PY
		jj commit -m "tool: Read config from /etc first

The user-level file shadowed the system one — the reverse of what every
other tool on the box does." >/dev/null 2>&1

		cat >net.py <<-'PY'
			import errno


			def connect(sock, addr):
			    while True:
			        try:
			            return sock.connect(addr)
			        except OSError as e:
			            if e.errno != errno.EAGAIN:
			                raise
		PY
		jj commit -m "tool: Retry the connect on EAGAIN

The kernel returns EAGAIN under load; the daemon treated it as fatal and
exited." >/dev/null 2>&1

		jj log -r '@-' --no-graph -T 'change_id.short()' >"$dir/retry-rev"
		jj log -r '@--' --no-graph -T 'change_id.short()' >"$dir/config-rev"
	)
	revset=$(revset)

	echo "Scratch dir: $dir"
	echo
	echo "In Claude Code, run:"
	echo "  /plain-review $dir/prose/install.md"
	echo "  /plain-review $dir/prose/safety.md"
	echo "and from $repo:"
	echo "  /check-commit-messages $revset"
	echo
	echo "Then: $0 check"
}

assert_grep() {
	local label=$1 pattern=$2 file=$3
	if grep -qF -- "$pattern" "$file"; then
		echo "PASS $label"
	else
		echo "FAIL $label: '$pattern' missing from $file"
		fail=1
	fi
}

assert_no_grep() {
	local label=$1 pattern=$2 file=$3
	if grep -qF -- "$pattern" "$file"; then
		echo "FAIL $label: '$pattern' still in $file"
		fail=1
	else
		echo "PASS $label"
	fi
}

check() {
	[ -d "$dir" ] || {
		echo "no scratch dir at $dir, run '$0 setup' first"
		exit 1
	}

	assert_grep "justified em dash kept" "— not even on first run" "$dir/prose/safety.md"
	assert_no_grep "nominalization rewritten (safety)" "Utilization" "$dir/prose/safety.md"
	assert_no_grep "nominalization rewritten (install)" "Installation of" "$dir/prose/install.md"
	assert_no_grep "two-idea semicolon split (install)" ";" "$dir/prose/install.md"

	local revset desc
	revset=$(revset)
	desc=$(cd "$repo" && jj log -r "$(cat "$dir/retry-rev")" --no-graph -T description)
	if grep -qF ';' <<<"$desc"; then
		echo "FAIL two-idea semicolon split (commit): $desc"
		fail=1
	else
		echo "PASS two-idea semicolon split (commit)"
	fi

	local out
	out=$(cd "$repo" && jj log -r "$revset" --no-graph \
		-T 'commit_id.short() ++ "\x01" ++ description ++ "\x02"' |
		awk -v limit=50 -v prefix_re='^[a-z*]+: ' -f "$awk_check" |
		grep -v '^COMMIT ' || true)
	if [ -n "$out" ]; then
		echo "FAIL awk check clean: $out"
		fail=1
	else
		echo "PASS awk check clean"
	fi

	exit "$fail"
}

run() {
	setup >/dev/null
	local revset
	revset=$(revset)
	for f in install.md safety.md; do
		(cd "$dir" && claude -p "/plain-review prose/$f" --permission-mode acceptEdits >/dev/null </dev/null)
	done
	(cd "$repo" && claude -p "/check-commit-messages $revset" --permission-mode acceptEdits >/dev/null </dev/null)
	check
}

case "${1:-}" in
setup | check | run) "$1" ;;
*)
	echo "usage: $0 setup|check|run"
	exit 2
	;;
esac
