bindkey -v
KEYTIMEOUT=5	# 50ms to complete a key sequence; reduces Esc lag in vi mode

# History navigation
bindkey "^P" history-incremental-search-backward
bindkey "^N" history-incremental-search-forward
# ^R: fzf history search (replaces the built-in)

# ^T: paste a file/directory path from fzf into the command line

# zsh-autosuggestions:
# Accept with ^y for consistency with ins-completion and blink-cmp
# Esc+W: vi-forward-word

bindkey "^y" autosuggest-accept
bindkey "^f" autosuggest-accept

# Unbind <Esc>: (execute-named-cmd)
bindkey -r "\e:"

# Unbind C-l (clear-screen)
bindkey -r "\C-l"
