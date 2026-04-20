# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set positional-arguments := true
set shell := ["sh", "-l", "-c"]

hostname := `hostname -s`

default:
    @just --list

bootstrap: check-nix
    nix run home-manager -- switch --flake ".#{{ hostname }}"
    pre-commit install

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
    nix flake update
    just build
    just switch
    just update-linters
    git add --update && git commit -m "nix: update flake and tools"

build:
    nix flake check

gc:
    nix-collect-garbage -d

nix-search *args:
    nix search nixpkgs "$@"

news:
    home-manager news --flake ".#{{ hostname }}"

switch:
    home-manager switch --flake ".#{{ hostname }}"

lint:
    pre-commit run

lint-all:
    pre-commit run --all-files

update-linters:
    pre-commit autoupdate
