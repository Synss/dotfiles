# vim: syn=zsh

for f in $ZDOTDIR/conf.d/*.zsh; do source "$f"; done
() { for f; do source "$f"; done } $ZDOTDIR/conf.d/*.local(N)

[ -f /etc/zsh/newuser.zshrc.recommended ] && \
  source /etc/zsh/newuser.zshrc.recommended
