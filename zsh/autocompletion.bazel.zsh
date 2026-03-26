# vim: syn=zsh
# Zsh completion for Bazel, loaded via bash completion compatibility layer.
# bashcompinit provides: complete, compgen, COMPREPLY
# BASH_REMATCH provides bash-compatible regex match array indexing

setopt BASH_REMATCH
autoload -U compinit bashcompinit
# compinit may already be loaded by the main autocompletion file; only init if needed
(( ${+functions[compdef]} )) || compinit
bashcompinit
source "${0:A:h}/autocompletion.bazel.bash"
