# vim: syn=zsh

for f in $ZDOTDIR/conf.d/*.zsh; do source "$f"; done

[ -f /etc/zsh/newuser.zshrc.recommended ] && \
  source /etc/zsh/newuser.zshrc.recommended

[ -f "$HOME/.config/zsh/zshrc.local" ] && . "$HOME/.config/zsh/zshrc.local"
