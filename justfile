# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set shell := ["sh", "-l", "-c"]

bootstrap:
    nix run home-manager -- switch --flake "./nix#$(hostname)"
    pre-commit install
    just update-vim

update:
    nix flake update ./nix
    just build
    just switch
    just update-vim

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
