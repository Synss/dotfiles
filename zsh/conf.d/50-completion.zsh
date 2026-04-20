# Ref https://thevaluable.dev/zsh-completion-guide-examples/

if [[ $OSTYPE == darwin* ]]; then
    __CACHE_DIR="$HOME/Library/Caches/zsh"
else
    __CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi
[[ -d "$__CACHE_DIR" ]] || mkdir "$__CACHE_DIR"


# --- options ---

zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*' verbose true

# Pretty print
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{green}%B-- %d --%b%f'
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches --%f'
zstyle ':completion:*:messages' format ' %F{purple}%B -- %d --%b%f'

# Group by tag
zstyle ':completion:*' group-name ''

# Caching
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${__CACHE_DIR}/.zcompcache"

# Menu after <Tab><Tab>
zstyle ':completion:*' menu select


unset __CACHE_DIR
