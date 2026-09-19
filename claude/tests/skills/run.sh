#!/usr/bin/env bash
# Dispatcher for the per-skill test suites in suites/. See README.md.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=claude/tests/skills/lib/deps.sh
source "$here/lib/deps.sh"

suites=(plain-review diataxis-review check-commit-messages)

usage() {
	echo "usage: $0 setup|check|run"
	echo "       $0 <suite> [setup|check|run]"
	echo "suites: ${suites[*]}"
	exit 2
}

is_suite() {
	local name=$1 s
	for s in "${suites[@]}"; do
		[ "$s" = "$name" ] && return 0
	done
	return 1
}

main() {
	check_deps

	case "${1:-}" in
	setup | check | run)
		local action=$1 fail=0 s
		for s in "${suites[@]}"; do
			"$here/suites/$s.sh" "$action" || fail=1
		done
		exit "$fail"
		;;
	"")
		usage
		;;
	*)
		is_suite "$1" || usage
		local suite=$1
		shift
		exec "$here/suites/$suite.sh" "${1:-run}"
		;;
	esac
}

main "$@"
