#!/usr/bin/env bash

set -euo pipefail

main() {
	local host
	host=${1:-$(hostname -s)}

	local restart=0

	log info bootstrap_start platform="$(uname -s)"
	install_nix
	switch "$host"
	colocate_jj
	log info bootstrap_ok

	if [ "$restart" -ne 0 ]; then
		# shellcheck disable=SC2016
		echo 'Bootstrapping done.  Restart your shell with "exec $SHELL -l".'
	fi
	exit "$restart"
}

request_restart() {
	restart=1
}

log() {
	# logfmt (github.com/kr/logfmt)
	local level=$1
	local event=$2
	shift 2

	printf >&2 'ts=%s level=%s event=%s%s\n' \
		"$(date -u +%FT%TZ)" "$level" "$event" "${*:+ $*}"
}

install_nix() {
	command -v nix &>/dev/null && return 0

	log info step_start step=install_nix
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install ${CI:+--no-confirm}
	request_restart
	# shellcheck disable=SC1091
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	log info step_ok step=install_nix
}

switch() {
	local host="$1"
	log info step_start step=switch_home_manager
	nix run home-manager -- switch --flake ".#${host}"
	log info step_ok step=switch_home_manager
}

colocate_jj() {
	[ -d .jj ] && return 0

	log info step_start step=colocate_jj
	git colocate
	log info step_ok step=colocate_jj
}

main "$@"
