for f in $ZDOTDIR/conf.d/*.zsh; do source "$f"; done
() { for f; do source "$f"; done } $ZDOTDIR/conf.d/*.local(N)
