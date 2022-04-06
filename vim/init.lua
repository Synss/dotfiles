-- Memo
--   * `set` -> `vim.opt`
--   * `let` -> `vim.g`

-- Helper functions for mapping
function noremap(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = false })
end

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true })
end

function nmap(shortcut, command)
  -- normal mode
  map("n", shortcut, command)
end

function nnoremap(shortcut, command)
  -- normal mode
  noremap("n", shortcut, command)
end

function tnoremap(shortcut, command)
  -- terminal mode
  noremap("t", shortcut, command)
end

-- Space as leader (let mapleader="<Space>")
--vim.g.mapleader = "<Space>"
nnoremap("<Space>", "<Nop>")
nnoremap("<Space>", "<Leader>")

-- Tab behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.cmd 'autocmd FileType make set noexpandtab'

-- Case insensitive matching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Color scheme
vim.g.solarized_termcolors = 256
vim.cmd 'colorscheme solarized'
vim.cmd 'set bg=light'

-- Split creation
nmap("<leader>H", ":topleft vnew<cr>")
nmap("<leader>J", ":botright new<cr>")
nmap("<leader>K", ":topleft new<cr>")
nmap("<leader>L", ":botright vnew<cr>")

nmap("<leader>h", ":leftabove vnew<cr>")
nmap("<leader>j", ":rightbelow new<cr>")
nmap("<leader>k", ":leftabove new<cr>")
nmap("<leader>l", ":rightbelow vnew<cr>")

-- Split navigation
nnoremap("<C-H>", "<C-W><C-H>")
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")

-- Delete buffer with bbye
nnoremap("<leader>bd", ":Bdelete<CR>")

-- Reformat paragraph
nnoremap("<leader>q", "gq")
nnoremap("<leader>Q", "{gq}")
