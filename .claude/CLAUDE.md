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
`nix/packages/` for overlay derivations). This repo no longer uses Mason.

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
re-applies the per-server override files through `vim.lsp.config()` to
put them back on top.

`gh_actions_ls` overrides `cmd` because the Nix package installs the
binary as `actions-languageserver`, not `gh-actions-language-server`.

## Nix overlay

`nix/packages/` holds local overlay derivations, auto-discovered by
`flake.nix` from directory name. Two kinds:

- built from source, for a package missing from nixpkgs (e.g.
  `ansible-language-server/`)
- a wrapper around an existing nixpkgs derivation, to bake in a runtime
  dependency via `makeWrapper` (e.g. `nil/`)

A wrapper that reuses its own attribute name must take that attribute as
an explicit `callPackage` argument, not an auto-arg. See
`selfOverrideArgs` in `flake.nix` for why.
