test -d "$ZDOTDIR/plugins/zsh-autosuggestions.git" || return 0

source "$ZDOTDIR/plugins/zsh-autosuggestions.git/zsh-autosuggestions.plugin.zsh"

# Ctrl-f: accept full suggestion; use vi mode for more granular selection
bindkey '^f' autosuggest-accept
