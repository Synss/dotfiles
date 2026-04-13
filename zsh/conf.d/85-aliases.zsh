if command -v xdg-open >/dev/null; then
	alias open="xdg-open"
elif command -v gnome-open >/dev/null; then
	alias open="gnome-open"
fi

if command -v photoflare >/dev/null; then
	alias paint="photoflare &>/dev/null"
elif command -v pinta >/dev/null; then
	alias paint=pinta
fi
