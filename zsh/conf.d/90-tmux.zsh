command -v tmux >/dev/null || return 0

[ -z "$TMUX" ] && tmux new-session -A -s main
