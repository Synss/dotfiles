export LANG=en_US.UTF-8

[ -d "/usr/local/lib" ] && export LD_LIBRARY_PATH="/usr/local/lib"

if command -v nvim >/dev/null; then export EDITOR=nvim; else export EDITOR=vi; fi

if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
elif [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
	export PATH="$PATH:$HOME/go/bin"
fi
