# Neovim configuration

## Per-repo LSP overrides

Per-repo LSP config is supported via `vim.opt.exrc`, which loads `.vim.lua` from the repo root
if present.

Add `.vim.lua` to `.git/info/exclude` to avoid tracking it:

```
# .git/info/exclude
.vim.lua
```

Restart Neovim in the repo root. It will prompt to trust `.vim.lua`. Accept it with `:trust .vim.lua`.

Example: disable `yamlls` formatting in a repo by creating `.vim.lua` in the repo root:

```lua
vim.lsp.config("yamlls", {
    settings = { yaml = { format = { enable = false } } },
})
```
