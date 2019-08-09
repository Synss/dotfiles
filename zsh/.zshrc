# vim: syn=zsh

# setup environment
export LANG=en_US.UTF-8
[ -x "$(which nvim)" ] && export EDITOR=nvim || export EDITOR=vi
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH
[ -d "/usr/local/lib" ] && export LD_LIBRARY_PATH="/usr/local/lib"

. $ZDOTDIR/aliases
. $ZDOTDIR/hashed_dirs
. $ZDOTDIR/history
. $ZDOTDIR/options
. $ZDOTDIR/autocompletion
. $ZDOTDIR/prompt

# Keyboard bindings (doc in zshcontrib(1) )
autoload zkbd

# Mime setup - associate extensions

[ -f /etc/zsh/newuser.zshrc.recommended ] && \
  source /etc/zsh/newuser.zshrc.recommended

[ $(uname) = "Darwin" ] && . $ZDOTDIR/zshrc_darwin
[ -f "$HOME/.config/zsh/zshrc.local" ] && . "$HOME/.config/zsh/zshrc.local"
