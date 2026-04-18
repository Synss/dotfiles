if command -v eza >/dev/null; then
    # Note: There's already an `lt` alias.
    alias tree="eza -T"
fi

if command -v photoflare >/dev/null; then
	alias paint="photoflare &>/dev/null"
elif command -v pinta >/dev/null; then
	alias paint=pinta
fi

if command -v rg >/dev/null; then
    alias ack=rg
fi

if command -v xdg-open >/dev/null; then
	alias open="xdg-open"
elif command -v gnome-open >/dev/null; then
	alias open="gnome-open"
fi
