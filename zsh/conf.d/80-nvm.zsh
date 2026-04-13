[ -d "$HOME/.nvm" ] || return 0

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
autoload -U +X bashcompinit && bashcompinit
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
