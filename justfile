# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set shell := ["sh", "-l", "-c"]

hostname := `hostname -s`

default:
    @just --list

bootstrap: check-nix
    nix run home-manager -- switch --flake "./nix#{{ hostname }}"
    pre-commit install
    just update-vim
    just update-zsh

[private]
check-nix:
    #!/usr/bin/env bash
    set -euo pipefail

    if ! command -v nix >/dev/null 2>&1; then
        echo "--- Installing Nix via Determinate Systems..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
        echo '--- Nix installed.  Restart your shell with "exec $SHELL -l".'
        exit 1
    fi

update:
    nix flake update --flake ./nix
    just build
    just switch
    @just update-vim & just update-zsh & just update-linters
    git add --update && git commit -m "nix: update flake and tools"

build:
    nix flake check ./nix

gc:
    nix-collect-garbage -d

news:
    home-manager news --flake "./nix#{{ hostname }}"

switch:
    home-manager switch --flake "./nix#{{ hostname }}"

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
