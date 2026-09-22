#!/usr/bin/env bash

set -euo pipefail

log() {
	# logfmt (github.com/kr/logfmt)
	local level=$1
	local event=$2
	shift 2

	printf >&2 'ts=%s level=%s event=%s%s\n' \
		"$(date -u +%FT%TZ)" "$level" "$event" "${*:+ $*}"
}

main() {
	command -v nix &>/dev/null && return 0

	local host
	host=${1:-$(hostname -s)}

	log info bootstrap_start platform="$(uname -s)"

	log info step_start step=install_nix
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ${CI:+--no-confirm}
	# shellcheck disable=SC1091
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	log info step_ok step=install_nix

	log info step_start step=switch_home_manager
	nix run home-manager -- switch --flake ".#${host}"
	log info step_ok step=switch_home_manager

	log info bootstrap_ok

	# shellcheck disable=SC2016
	echo 'Bootstrapping done.  Restart your shell with "exec $SHELL -l".'
	exit 1
}

main "$@"
