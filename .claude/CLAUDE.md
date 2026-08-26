# Dotfiles project notes

## Commit messages

Subject: prefixed with a lowercase component matching the area touched
(e.g. `vim:`, `nix:`, `claude:`, `zsh:`, `git:`). Use `*:` if the change
spans more than one area.

The prefix doesn't count toward the global policy's ~50 character limit.
For example, `vim: ` plus 50 characters is fine.

The first word after the lowercase prefix is capitalized. This
satisfies the global rule's capitalized-subject requirement: the prefix
sits outside the sentence, so capitalization starts at the first word
after it.

Otherwise, follow the global commit message policy.

## Neovim LSP

LSP servers are installed by Nix (see `nix/home.nix` packages,
`nix/packages/` for overlay derivations). Mason has been removed.

**`nvim-lspconfig` is required** even though it is never explicitly
`require`'d. nvim-lspconfig 2.x auto-registers `cmd`, `filetypes`, and
`root_markers` for all known servers via `vim.lsp.config()` on load.
Removing it leaves `vim.lsp.enable()` with no config and no clients
start.

Per-server overrides live in `nvim/lsp/<name>.lua`. A file there is not
enough on its own. Neovim merges every `lsp/<name>.lua` on the
runtimepath in runtimepath order, then lets any `vim.lsp.config()` call
override the result. nvim-lspconfig ships its own copies and sits after
`~/.config/nvim` on the runtimepath, so it wins. `nvim/plugin/lsp.lua`
re-applies our files through `vim.lsp.config()` to put them back on top.

`gh_actions_ls` overrides `cmd` because the Nix package installs the
binary as `actions-languageserver`, not `gh-actions-language-server`.

## Nix overlay

`ansible-language-server` and `actions-languageserver` are not in
nixpkgs. They are packaged as local overlay derivations in
`nix/packages/` using `stdenv.mkDerivation` + `fetchurl` from the npm
registry. The packages ship pre-compiled `dist/` bundles, so no build
step is needed.
