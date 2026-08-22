![Build Status](https://github.com/Synss/dotfiles/actions/workflows/pre-commit.yml/badge.svg?branch=main)

# dotfiles

Configuration for

- claude
- neovim
- tmux
- zsh

git and jj are configured in `nix/home.nix`.

## Installation

Run

```sh
./bootstrap-just.sh bootstrap
```

to setup a new machine. `justfile` has the targets for everything else.

## Layout

- `claude/` — see [`claude/README.md`](claude/README.md).
- `nix/` — flake modules and package list. See [`nix/README.md`](nix/README.md).
- `nvim/` — see [`nvim/README.md`](nvim/README.md).
- `zsh/` — see [`zsh/README.md`](zsh/README.md).
- `shared/theme-config.json` — the colorscheme, read by nvim, zsh and glow.
- `scripts/` — lists the apt packages of a host. Not deployed.
