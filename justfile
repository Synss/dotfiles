# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set positional-arguments
set shell := ["sh", "-l", "-c"]

hostname := `hostname -s`

default:
    @just --list

bootstrap host=hostname: check-nix
    nix run home-manager -- switch --flake ".#{{ host }}"

[private]
check-nix:
    #!/usr/bin/env -S bash -euo pipefail
    command -v nix >/dev/null 2>&1 && exit 0

    echo "--- Instareturnlling Nix via Determinate Systems..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix\
            | sh -s -- install ${CI:+--no-confirm}
    echo '--- Nix installed.  Restart your shell with "exec $SHELL -l".'
    exit 1

update:
    [ "$(jj log -r @ --no-graph -T 'empty')" = "false" ] && jj new || true
    just update-overlays
    nix flake update
    just build
    just switch
    jj commit -m "nix: update flake and tools"

[private]
update-overlays:
    #!/usr/bin/env -S bash -euo pipefail
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

        perl -i -pe "s/version = \"\Q$current\E\"/version = \"$latest\"/;
                     s|hash = \"sha256-[^\"]*\"|hash = \"$new_hash\"|" "$nix_file"

        echo "bumped $npm_pkg $current → $latest"
    }

    update_pkg nix/packages/actions-languageserver/package.nix   "@actions/languageserver"
    update_pkg nix/packages/ansible-language-server/package.nix  "@ansible/ansible-language-server"

[private]
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

sync-claude:
    #!/usr/bin/env -S bash -euo pipefail
    tmp=$(mktemp)
    jq -s '.[0] * .[1]' ~/.claude/settings.json claude/settings.json > "$tmp"
    mv "$tmp" ~/.claude/settings.json

check-lsp:
    nvim --headless -c "checkhealth vim.lsp" -c "qa!"

lint-all:
    @just lint-just
    @just lint-lua
    @just lint-nix
    @just lint-perl
    @just lint-shell

[private]
lint-just:
    #!/usr/bin/env -S nix develop --command bash -euo pipefail
    just --fmt --unstable

[private]
lint-lua:
    #!/usr/bin/env -S nix develop --command bash -euo pipefail
    lua-language-server --check .

[private]
lint-nix:
    #!/usr/bin/env -S nix develop --command bash -euo pipefail
    treefmt flake.nix nix/
    statix check --ignore 'vim/**' .
    deadnix --fail flake.nix nix/
    nix flake check

[private]
lint-perl:
    #!/usr/bin/env -S nix develop --command bash -euo pipefail
    perlcritic .
    git ls-files '*.pl' | xargs -n1 perltidy --assert-tidy -st -se >/dev/null

[private]
lint-shell:
    #!/usr/bin/env -S nix develop --command bash -euo pipefail
    shellcheck -- $(git ls-files '*.sh')
    shfmt -w .
