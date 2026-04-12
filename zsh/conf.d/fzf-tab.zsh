command -v fzf >/dev/null || test -d "$ZDOTDIR/plugins/fzf-tab.plugins.zsh" || return 0

source "$ZDOTDIR/plugins/fzf-tab.git/fzf-tab.plugin.zsh"

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
