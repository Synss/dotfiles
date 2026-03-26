# vim: syn=zsh

# setup environment
export LANG=en_US.UTF-8
[ -x "$(which direnv)" ] && eval "$(direnv hook zsh)"
[ -x "$(which nvim)" ] && export EDITOR=nvim || export EDITOR=vi
[ -d "/usr/local/lib" ] && export LD_LIBRARY_PATH="/usr/local/lib"

if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
elif [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
	export PATH="$PATH:$HOME/go/bin"
fi

. $ZDOTDIR/aliases
. $ZDOTDIR/hashed_dirs
. $ZDOTDIR/history
. $ZDOTDIR/options
. $ZDOTDIR/autocompletion
. $ZDOTDIR/autocompletion.bazel.zsh
. $ZDOTDIR/prompt

# Keyboard bindings (doc in zshcontrib(1) )
autoload zkbd

# Mime setup - associate extensions

[ -f /etc/zsh/newuser.zshrc.recommended ] && \
  source /etc/zsh/newuser.zshrc.recommended

[ $(uname) = "Darwin" ] && . $ZDOTDIR/zshrc_darwin
[ -f "$HOME/.config/zsh/zshrc.local" ] && . "$HOME/.config/zsh/zshrc.local"

# pnpm
export PNPM_HOME="/home/mathiaslaurin/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
