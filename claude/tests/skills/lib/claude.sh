#!/usr/bin/env bash
# Drives a Claude Code slash command against a fixture and captures its
# output for diagnostics instead of discarding it.
#
# Usage: run_claude_cmd <dir> <slash-command> <log-file>
run_claude_cmd() {
	local dir=$1 cmd=$2 log=$3
	mkdir -p "$(dirname "$log")"
	(cd "$dir" && claude -p "$cmd" --permission-mode acceptEdits) >"$log" 2>&1 </dev/null
}
