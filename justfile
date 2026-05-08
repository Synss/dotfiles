# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set positional-arguments
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
    [ "$(jj log -r @ --no-graph -T 'empty')" = "false" ] && jj new || true
    just update-overlays
    nix flake update
    just build
    just switch
    just update-linters
    jj commit -m "nix: update flake and tools"

update-overlays:
    #!/usr/bin/env bash
    set -euo pipefail

    update_pkg() {
        local nix_file="$1"
        local npm_pkg="$2"

        local current
        current=$(perl -ne 'print "$1\n" and exit if /version = "(.*)";/' "$nix_file")

        local latest
        latest=$(pnpm view "$npm_pkg" version 2>/dev/null)

        [ "$current" = "$latest" ] && return

        local url
        url=$(pnpm view "$npm_pkg" dist.tarball 2>/dev/null)

        local new_hash
        new_hash=$(nix store prefetch-file --hash-type sha256 --json "$url" | jq -r '.hash')

        perl -i -pe "s/version = \"$current\"/version = \"$latest\"/;
                     s|hash = \"sha256-[^\"]*\"|hash = \"$new_hash\"|" "$nix_file"

        echo "bumped $npm_pkg $current → $latest"
    }

    update_pkg nix/packages/actions-languageserver.nix   "@actions/languageserver"
    update_pkg nix/packages/ansible-language-server.nix  "@ansible/ansible-language-server"

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
    cp claude/settings.json ~/.claude/settings.json

sync-claude:
    cp ~/.claude/settings.json claude/settings.json

check-lsp:
    nvim --headless -c "checkhealth vim.lsp" -c "qa!"

lint:
    pre-commit run

lint-all:
    pre-commit run --all-files

update-linters:
    pre-commit autoupdate
