# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set shell := ["sh", "-l", "-c"]

default:
    @just --list

bootstrap:
    nix run home-manager -- switch --flake "./nix#$(hostname)"
    pre-commit install
    just update-vim
    just update-zsh

update:
    nix flake update ./nix
    just build
    just switch
    just update-vim
    just update-zsh
    just update-linters

build:
    nix flake check ./nix

gc:
    nix-collect-garbage -d

news:
    home-manager news --flake "./nix#$(hostname)"

switch:
    home-manager switch --flake "./nix#$(hostname)"

update-vim:
    #!/usr/bin/env bash
    stamp="$(git rev-parse --show-toplevel)/.vim_submodule_updated"
    if [ ! -f "$stamp" ] || [ -n "$(find "$stamp" -mmin +1440 2>/dev/null)" ]; then
        git submodule update --init --remote vim/pack/plugins/start
        touch "$stamp"
    fi

update-zsh:
    #!/usr/bin/env bash
    stamp="$(git rev-parse --show-toplevel)/.zsh_submodule_updated"
    if [ ! -f "$stamp" ] || [ -n "$(find "$stamp" -mmin +1440 2>/dev/null)" ]; then
        git submodule update --init --remote zsh/plugins
        touch "$stamp"
    fi

lint:
    pre-commit run

lint-all:
    pre-commit run --all-files

update-linters:
    pre-commit autoupdate
