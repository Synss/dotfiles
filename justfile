switch:
    nix run home-manager -- switch --impure --flake "./nix#$(hostname)"
    just update-vim

update-vim:
    #!/usr/bin/env bash
    stamp="$(git rev-parse --show-toplevel)/.vim_submodule_updated"
    if [ ! -f "$stamp" ] || [ -n "$(find "$stamp" -mmin +1440 2>/dev/null)" ]; then
        git submodule update --init --remote vim/pack/plugins/start
        touch "$stamp"
    fi
