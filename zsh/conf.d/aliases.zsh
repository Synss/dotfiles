function s { [ $# = 0 ] && sudo -s || sudo "$@" }

# Aliases

if command -v rg >/dev/null; then
	alias ack=rg
elif command -v ag >/dev/null; then
	alias ack=ag
fi

command -v bazel >/dev/null   && alias bzllock="bazel mod deps --lockfile_mode=update"
command -v eza >/dev/null     && alias tree="eza -T"
command -v jq >/dev/null      && alias jqresults="jq '.. | objects | select(has(\"results\") and (.results | length > 0)) | .results'"
command -v libtree >/dev/null && alias ldt=libtree

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

alias -g D='| dot -Tpdf'
alias -g G='| grep'
alias -g H='| head'
alias -g L='| less'
alias -g N='&> /dev/null'
alias -g P='| open -fa Preview'
alias -g T='| tail'
alias -g XB="':(exclude)MODULE.bazel.lock'"
