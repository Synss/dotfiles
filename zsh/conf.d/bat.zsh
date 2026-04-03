command -v bat >/dev/null || command -v batcat >/dev/null || return 0

# Help bat picking light or dark themes
if [[ -n "$COLORFGBG" ]] && [[ ${COLORFGBG##*;} -lt 8 ]]; then
	export BAT_THEME="gruvbox-dark"
else
	export BAT_THEME="gruvbox-light"
fi

__BAT=bat
if command -v batcat >/dev/null; then
	# Ubuntu/Debian renames bat -> batcat
	__BAT=batcat
	alias bat=batcat
fi

alias cat="$__BAT --paging=never"

alias -g -- -h="-h 2>&1 | $__BAT --language=help --style=plain"
alias -g -- --help="--help 2>&1 | $__BAT --language=help --style=plain"

export MANPAGER="$__BAT -plman"

unset __BAT
