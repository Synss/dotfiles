function s { [ $# = 0 ] && sudo -s || sudo "$@" }

# Aliases

if command -v xdg-open >/dev/null; then
	alias open="xdg-open"
elif command -v gnome-open >/dev/null; then
	alias open="gnome-open"
fi

if command -v photoflare >/dev/null; then
	alias paint="photoflare &>/dev/null"
elif command -v pinta >/dev/null; then
	alias paint=pinta
fi

# Global Aliases

if command -v xclip >/dev/null; then
	alias -g C='| xclip -in -selection clipboard'
elif command -v pbcopy >/dev/null; then
	alias -g C='| pbcopy'
fi

alias -g G='| grep'
alias -g H='| head'
alias -g L='| less'
alias -g P='| open -fa Preview'
alias -g T='| tail'
