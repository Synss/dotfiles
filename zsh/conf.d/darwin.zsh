# vim: set syn=zsh

[[ $OSTYPE == darwin* ]] || return

# use colors for BSD ls
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"

# MacPorts
[ -d "$HOME/macports" ] &&
	export PATH="$HOME/macports/bin:$PATH" &&
	export MANPATH="$HOME/macports/share/man:$MANPATH" &&
	hash -d ports="$HOME/macports/var/macports/sources/rsync.macports.org/release/tarballs/ports"
