command -v dot >/dev/null || return 0

alias -g D='| dot -Tpdf'
