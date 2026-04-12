# Core shell config — explicit order matters
source "$ZDOTDIR/core.d/options.zsh"
source "$ZDOTDIR/core.d/history.zsh"
source "$ZDOTDIR/core.d/aliases.zsh"
source "$ZDOTDIR/core.d/completion.zsh"
source "$ZDOTDIR/core.d/prompt.zsh"

# Tool integrations — alphabetical order is fine
for f in $ZDOTDIR/conf.d/*.zsh; do source "$f"; done
() { for f; do source "$f"; done } $ZDOTDIR/conf.d/*.local(N)

# Keybindings — after plugins are loaded
source "$ZDOTDIR/core.d/keybindings.zsh"
