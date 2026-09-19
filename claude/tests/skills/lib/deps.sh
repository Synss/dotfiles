#!/usr/bin/env bash
# Fails fast with a clear message if a required binary is missing.
check_deps() {
	local missing=() bin
	for bin in claude jj grep awk diff; do
		command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
	done
	if [ "${#missing[@]}" -gt 0 ]; then
		echo "missing required commands: ${missing[*]}" >&2
		exit 1
	fi
}
