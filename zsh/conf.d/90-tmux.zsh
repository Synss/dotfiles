command -v tmux >/dev/null || return 0

[ -z "$TMUX" ] && ! tmux has-session 2>/dev/null && tmux new-session -A -s main
