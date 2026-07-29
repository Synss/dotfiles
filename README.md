![Build Status](https://github.com/Synss/dotfiles/actions/workflows/pre-commit.yml/badge.svg?branch=main)

# dotfiles

Configuration for claude, neovim, tmux and zsh, plus git and jj. Deployed with
Nix and Home Manager, which generates whatever has no directory of its own here.

New machine:

```sh
./bootstrap-just.sh bootstrap
```

`justfile` is the entry point for everything else.

## Where things are

- `nix/` — flake modules, package list → [nix/README.md](nix/README.md)
- `nvim/` → [nvim/README.md](nvim/README.md)
- `zsh/` → [zsh/README.md](zsh/README.md)
- `shared/theme-config.json` — the single colorscheme, read by nvim, zsh and glow
- `scripts/` — host bookkeeping, not deployed
