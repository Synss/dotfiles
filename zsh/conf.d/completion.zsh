# vim: syn=zsh

fpath=($ZDOTDIR/completions $fpath)

autoload -U compinit
compinit
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
# cache
zstyle ':completion::complete:*' use-cache 1

# SSH Completion (http://dotfiles.org/~Ryuzaki/.zshrc)
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# Bazel completion via bash compatibility layer
# bashcompinit provides: complete, compgen, COMPREPLY
# BASH_REMATCH provides bash-compatible regex match array indexing
setopt BASH_REMATCH
autoload -U bashcompinit
bashcompinit
source "$ZDOTDIR/completions/bazel.bash"
