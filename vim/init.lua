-- Memo
--   * `set` -> `vim.opt`
--   * `let` -> `vim.g`

vim.g.mapleader = " "

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

local function read_theme_config(path)
  local file = io.open(path, "r")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  local ok, config = pcall(vim.json.decode, content)
  return ok and config or nil
end

local function read_bg_preference(path)
  local file = io.open(path, "r")
  if not file then return "dark" end
  local bg = file:read("*l")
  file:close()
  return (bg == "light") and "light" or "dark"
end

local function colorscheme_for(config, bg)
  if not config then return nil end
  return config.colorscheme or config[bg]
end

local function apply_theme(bg, colorscheme)
  if colorscheme then vim.cmd("colorscheme " .. colorscheme) end
  vim.o.background = bg
end

-- I/O: write bg to per-instance file so :terminal shells can read it
local function write_instance_theme(bg)
  local socket = vim.v.servername
  if socket ~= "" then
    os.execute("echo " .. bg .. " > " .. socket .. ".theme")
  end
end

local function register_commands(config, pref_path)
  local function switch(bg)
    apply_theme(bg, colorscheme_for(config, bg))
    write_instance_theme(bg)
    os.execute("echo " .. bg .. " > " .. pref_path)
  end
  vim.api.nvim_create_user_command("Dark",  function() switch("dark")  end, {})
  vim.api.nvim_create_user_command("Light", function() switch("light") end, {})
end

local script_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local pref_path  = os.getenv("HOME") .. "/.theme-preference"
local config     = read_theme_config(script_dir .. "/theme-config.json")
local bg         = read_bg_preference(pref_path)

apply_theme(bg, colorscheme_for(config, bg))
write_instance_theme(bg)
register_commands(config, pref_path)

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local socket = vim.v.servername
    if socket ~= "" then os.remove(socket .. ".theme") end
  end,
})

-- Split creation
vim.keymap.set("n", "<leader>H", ":topleft vnew<cr>")
vim.keymap.set("n", "<leader>J", ":botright new<cr>")
vim.keymap.set("n", "<leader>K", ":topleft new<cr>")
vim.keymap.set("n", "<leader>L", ":botright vnew<cr>")

vim.keymap.set("n", "<leader>h", ":leftabove vnew<cr>")
vim.keymap.set("n", "<leader>j", ":rightbelow new<cr>")
vim.keymap.set("n", "<leader>k", ":leftabove new<cr>")
vim.keymap.set("n", "<leader>l", ":rightbelow vnew<cr>")

-- Split navigation
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")

vim.keymap.set("t", "<C-H>", "<C-\\><C-n><C-W><C-H>")
vim.keymap.set("t", "<C-J>", "<C-\\><C-n><C-W><C-J>")
vim.keymap.set("t", "<C-K>", "<C-\\><C-n><C-W><C-K>")
vim.keymap.set("t", "<C-L>", "<C-\\><C-n><C-W><C-L>")

-- fzf - `files` and `live_grep` now, `buffers` and `lsp_references`
--       might be useful as well.
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>ff", ":FzfLua oldfiles<CR>")
vim.keymap.set("n", "<leader>g", ":FzfLua live_grep<CR>")

require('fzf-lua').setup({
    files = {
        cmd = "fd --type f --hidden --exclude .git --exclude .gitmodules",
    },
    grep = {
        rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
    }
})

-- Delete buffer with bbye
vim.keymap.set("n", "<leader>bd", ":Bdelete this<CR>")

-- Reformat paragraph
vim.keymap.set("n", "<leader>q", "gq")
vim.keymap.set("n", "<leader>Q", "{gq}")

-- LSP diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { silent = true })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local opts = { noremap = true, silent = true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
local servers = {
    'ansiblels',
    'bazelrc_lsp',
    'clangd',
    'cssls',
    'nil_ls',
    'pyright',
    'starlark_rust'
}

-- Not every yaml file is an ansible file.
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'roles/**/*.yml' },
    callback = function() vim.bo.filetype = 'yaml.ansible' end,
})

vim.lsp.config('ansiblels', {
    filetypes = { 'yaml.ansible' },
})

-- Run `nixfmt` on save
vim.lsp.config('nil_ls', {
    settings = {
        ['nil'] = {
            formatting = { command = { "nixfmt" } },
        }
    }
})

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

for _, lsp in pairs(servers) do
  vim.lsp.enable(lsp)
end

-- Oil mapping to `-`, like vim-vinegar
require('oil').setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require('lualine').setup({
  sections = {
    lualine_c = { { 'filename', path = 1 } }
  }
})
