# vim: syn=zsh

command -v fd >/dev/null || command -v fdfind >/dev/null || return 0

# Ubuntu/Debian renames fd -> fdfind
command -v fdfind >/dev/null && alias fd=fdfind
