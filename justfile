# Login shell so /etc/profile.d/nix.sh is sourced and ~/.nix-profile/bin is on PATH.

set positional-arguments
set shell := ["sh", "-l", "-c"]

hostname := `hostname -s`

default:
    @just --list

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

lint: lint-just lint-lua lint-nix lint-ruby lint-shell

[private]
lint-just:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    just --fmt --check --unstable

[private]
lint-lua:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    lua-language-server --check .

[private]
lint-nix:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    rc=0
    git ls-files -z flake.nix 'nix/*.nix' | xargs -0 nixfmt --check || rc=$?
    statix check --ignore 'vim/**' . || rc=$?
    deadnix --fail flake.nix nix/ || rc=$?
    nix flake check || rc=$?
    exit $rc

[private]
lint-ruby:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    rubocop

[private]
lint-shell:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    git ls-files -z '*.sh' | xargs -0 -r shellcheck --
    git ls-files -z | perl -0 -ne 'print if -f' | xargs -0 shfmt -f | xargs -r shfmt --diff

fix: fix-just fix-nix fix-ruby fix-shell lint

[private]
fix-just:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    just --fmt --unstable

[private]
fix-nix:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    git ls-files -z flake.nix 'nix/*.nix' | xargs -0 nixfmt
    statix fix --ignore 'vim/**' .
    deadnix --edit flake.nix nix/

[private]
fix-ruby:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    rubocop --autocorrect-all

[private]
fix-shell:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    { git ls-files -z '*.sh' | xargs -0 -r shellcheck -f diff -- || true; } | git apply --allow-empty
    git ls-files -z | perl -0 -ne 'print if -f' | xargs -0 shfmt -f | xargs -r shfmt --write

test *args:
    #!/usr/bin/env -S nix develop --command bash -euxo pipefail
    case "${1:-}" in
    --with-junit) mkdir -p reports/bats && JUNIT=1 ;;
    '') ;;
    *) exit 2 ;;
    esac
    bats ${JUNIT:+--report-formatter junit --output reports/bats} -r tests
