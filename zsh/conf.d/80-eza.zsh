command -v eza >/dev/null || return 0

alias tree="eza -T"
alias ls=eza
alias ll="eza -l"
alias la="eza -a"
