# vim: syn=zsh

command -v vivid >/dev/null || return 0

export LS_COLORS="$(vivid generate ayu)"
