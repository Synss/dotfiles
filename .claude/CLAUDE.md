# Dotfiles project notes

## Neovim LSP

LSP servers are installed by Nix (see `nix/home.nix` packages, `nix/packages/` for overlay
derivations). Mason has been removed.

**`nvim-lspconfig` is required** even though it is never explicitly `require`'d. nvim-lspconfig
2.x auto-registers `cmd`, `filetypes`, and `root_markers` for all known servers via
`vim.lsp.config()` on load. Removing it leaves `vim.lsp.enable()` with no config and no clients
start.

`gh_actions_ls` has a `cmd` override in `vim/plugin/lsp.lua` because the Nix package installs
the binary as `actions-languageserver`, not `gh-actions-language-server`.

`groovyls` has a `cmd` override in `vim/plugin/lsp.lua` because the default expects
`java -jar groovy-language-server-all.jar` but the Nix package installs a wrapper script
named `groovy-language-server`.

## Nix overlay

`ansible-language-server` and `actions-languageserver` are not in nixpkgs. They are packaged as
local overlay derivations in `nix/packages/` using `stdenv.mkDerivation` + `fetchurl` from the
npm registry (packages ship pre-compiled `dist/` bundles, so no build step is needed).
