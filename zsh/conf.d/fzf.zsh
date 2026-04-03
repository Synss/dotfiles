# vim: syn=zsh

command -v fzf >/dev/null || return 0

if command -v fd >/dev/null; then
	FD=fd
elif command -v fdfind >/dev/null; then
	FD=fdfind
fi
[[ -v FD ]] && export FZF_DEFAULT_COMMAND="$FD --hidden --exclude .venv"

source <(fzf --zsh)
