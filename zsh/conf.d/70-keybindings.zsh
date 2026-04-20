bindkey -v
KEYTIMEOUT=5	# 50ms to complete a key sequence; reduces Esc lag in vi mode

# History navigation
bindkey "^P" history-incremental-search-backward
bindkey "^N" history-incremental-search-forward
# ^R: fzf history search (replaces the built-in)

# ^T: paste a file/directory path from fzf into the command line

# zsh-autosuggestions:
# ^F: accepts full suggestion
# Esc+W: vi-forward-word
bindkey "^f" autosuggest-accept

# Unbind C-l (clear-screen)
bindkey -r "\C-l"
