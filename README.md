![Build Status](https://github.com/Synss/dotfiles/actions/workflows/pre-commit.yml/badge.svg?branch=main)

# dotfiles

Configuration for

- claude
- neovim
- tmux
- zsh

git and jj are configured in `nix/home.nix`.

## Installation

To set up a new machine, add an entry to [`nix/hosts.nix`](nix/hosts.nix),
then run:

```sh
./bin/bootstrap.sh
```

## Layout

- `bin/` — executables used in this repo.
- `claude/` — see [`claude/README.md`](claude/README.md).
- `docs/` — cheat-sheets, call with `doc` on the commandline.
- `nix/` — flake modules and package list. See [`nix/README.md`](nix/README.md).
- `nvim/` — Neovim configuration.
- `zsh/` — see [`zsh/README.md`](zsh/README.md).
- `shared/theme-config.json` — the colorscheme, read by nvim, zsh and glow.
