# vim: syn=zsh

# setup environment
[ -x "$(which vim)" ] && export EDITOR=vim
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
