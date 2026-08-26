# Neovim

## LSP

### Per-repo overrides

Per-repo LSP config is supported via `vim.opt.exrc`, which loads `.vim.lua`
from the repo root if present.

Add `.vim.lua` to `.git/info/exclude` to avoid tracking it:

```shell
# .git/info/exclude
.vim.lua
```

Restart Neovim in the repo root. It will prompt to trust `.vim.lua`. Accept it
with `:trust .vim.lua`.

Example: disable `yamlls` formatting in a repo by creating `.vim.lua` in the
repo root:

```lua
vim.lsp.config("yamlls", {
    settings = { yaml = { format = { enable = false } } },
})
```

### Namespace

- `g` and `gr`
- `<Leader>lw`

### Format on save

Toggle with `:lua vim.b.format_on_save = {nil,false}`

## Splits

### Namespace

`<Leader>s`

## Clipboard

- N/V + `<Leader>{y,p,P}`: Yank, paste, and paste before from clipboard.

## Misc. shortcuts (abridged)

- Visual + `J`/`K`: Move selection down/up.
- Visual + `<`/`>`: Remove/add indentation.
- Normal + `<Leader>W`: Remove trailing whitespace.

## See Also

- [News](https://neovim.io/doc/user/news/#news)
- `which-key`
