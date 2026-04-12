HISTSIZE=999
HISTFILE="$HOME/.history"
HISTFILE="$HISTFILE-$(whoami)"
SAVEHIST=$HISTSIZE
HISTIGNORE="[bf]g:cd:df:exit:free:h:hh:l[al]:s:screen:which"

[ -n "$UID" ] && [ -n "$GID" ] &&
	touch "$HISTFILE" &&
	chown "$UID:$GID" "$HISTFILE"

bindkey "^P" history-incremental-search-backward
bindkey "^N" history-incremental-search-forward
