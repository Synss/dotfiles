# vim: syn=zsh

# Use fd if available.
if [ -x "$(command -v fd)" ]; then
	FD=fd
elif [ -x "$(command -v fdfind)" ]; then
	# Ubuntu/Debian renames fd -> fdfind
	FD=fdfind
fi
[[ -v FD ]] && export FZF_DEFAULT_COMMAND="$FD --hidden --exclude .venv"

command -v fzf >/dev/null && source <(fzf --zsh)
