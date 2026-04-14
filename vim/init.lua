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

-- Terminal
vim.g.shell = "zsh"

-- Make a few whitespace characters visible
-- nbsp: <C-k> <space> <space>
-- vim.opt.listchars = { nbsp = "␣", tab = "↹·" }
vim.opt.listchars = { nbsp = "␣", tab = "⇥ " }
vim.opt.list = true

-- Tab behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.cmd 'autocmd FileType make set noexpandtab'

-- Session management
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
local session_dir = vim.fn.stdpath("data") .. "/sessions"
if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, "p")
end

local function get_session_path()
    local cwd = vim.fn.getcwd():gsub("[/\\]", "%%"):gsub(":", "++")
    return session_dir .. "/" .. cwd .. ".vim"
end

local session_to_use = get_session_path()

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        if vim.fn.argc() == 0 and vim.fn.filereadable(session_to_use) == 1 then
            vim.cmd("source " .. vim.fn.fnameescape(session_to_use))
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("mksession! " .. vim.fn.fnameescape(session_to_use))
        end
    end,
})

-- Case insensitive matching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

-- Color scheme
-- 24-bit true-color support
if (vim.env.TMUX == nil or vim.env.TMUX == "") and vim.env.TERM_PROGRAM ~= "Apple_Terminal" then
  if vim.fn.has("termguicolors") == 1 then
    vim.opt.termguicolors = true
  end
end

vim.o.background='light'
vim.cmd 'colorscheme gruvbox'

-- Shortcut for switching between light and dark mode
vim.api.nvim_create_user_command('Dark', 'set background=dark', {})
vim.api.nvim_create_user_command('Light', 'set background=light', {})

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

tnoremap("<C-H>", "<C-\\><C-n><C-W><C-H>")
tnoremap("<C-J>", "<C-\\><C-n><C-W><C-J>")
tnoremap("<C-K>", "<C-\\><C-n><C-W><C-K>")
tnoremap("<C-L>", "<C-\\><C-n><C-W><C-L>")

-- fzf - `files` and `live_grep` now, `buffers` and `lsp_references`
--       might be useful as well.
nmap("<leader>f", ":FzfLua files<CR>")
nmap("<leader>g", ":FzfLua live_grep<CR>")

-- Delete buffer with bbye
nnoremap("<leader>bd", ":Bdelete this<CR>")

-- Reformat paragraph
nnoremap("<leader>q", "gq")
nnoremap("<leader>Q", "{gq}")

-- LSP config
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- LSP
local servers = { 'clangd', 'pylsp', 'pyright' }

-- Point pyright at the uv-managed venv (.venv in project root).
vim.lsp.config('pyright', {
    settings = {
        python = {
            venvPath = ".",
            venv = ".venv",
        }
    }
})

-- Make sure both plugins are loaded in the correct order.
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in pairs(servers) do
  vim.lsp.enable(lsp)
end

-- Oil mapping to `-`, like vim-vinegar
require('oil').setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

--
require('lualine').setup({
  sections = {
    lualine_c = { { 'filename', path = 1 } }
  }
})
