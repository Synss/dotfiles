test -f /etc/zsh/newuser.zshrc.recommended || return 0

autoload -U colors && colors

# On Debian, /etc/zsh/newuser.zshrc.recommended is sourced automatically.
# Rename or delete it to prevent it from overriding settings.
print "${fg_bold[yellow]}WARNING:${reset_color} /etc/zsh/newuser.zshrc.recommended exists and may override settings."
