if command -v xclip >/dev/null; then
	alias -g C='| xclip -in -selection clipboard'
elif command -v pbcopy >/dev/null; then
	alias -g C='| pbcopy'
fi

alias -g G='| grep'
alias -g H='| head'
alias -g L='| less'
alias -g T='| tail'
