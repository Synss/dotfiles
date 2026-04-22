-- Memo
--   * `set` -> `vim.opt`
--   * `let` -> `vim.g`

vim.g.mapleader = " "

-- Make a few whitespace characters visible
vim.opt.list = true
vim.opt.listchars = {
	nbsp = "␣",
	tab = "⇥ ",
	trail = "·",
}

-- Tab behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

require("session")

-- Case insensitive matching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false
vim.opt.swapfile = false

-- Time in ms to wait for mapped sequence to complete
vim.opt.timeoutlen = 200

-- Color scheme
if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	vim.opt.termguicolors = true
end

require("theme")

-- Split creation (<Leader>| / <Leader>- for quick splits; <Leader>w* for directional)
vim.keymap.set("n", "<Leader>|", "<Cmd>rightbelow vnew<CR>", { desc = "Split right" })
vim.keymap.set("n", "<Leader>-", "<Cmd>rightbelow new<CR>", { desc = "Split below" })

-- Split and terminal creation
local function map_split(key, cmd, label, terminal)
	local split = "<Cmd>" .. cmd .. "<CR>"
	vim.keymap.set("n", "<Leader>s" .. key, split, { desc = "Split " .. label })
	if terminal then
		vim.keymap.set("n", "<Leader>t" .. key, split .. "<Cmd>term<CR>", { desc = "Terminal " .. label })
	end
end

map_split("h", "leftabove vnew", "left", true)
map_split("j", "rightbelow new", "below", true)
map_split("k", "leftabove new", "above", true)
map_split("l", "rightbelow vnew", "right", true)

map_split("H", "topleft vnew", "far left")
map_split("J", "botright new", "far bottom")
map_split("K", "topleft new", "far top")
map_split("L", "botright vnew", "far right")

-- Split navigation
local function map_nav(key, cmd, desc)
	vim.keymap.set("n", key, cmd, { desc = desc })
	vim.keymap.set("t", key, "<C-\\><C-n>" .. cmd, { desc = desc })
end

map_nav("<C-h>", "<C-w><C-h>", "Go to left window")
map_nav("<C-j>", "<C-w><C-j>", "Go to bottom window")
map_nav("<C-k>", "<C-w><C-k>", "Go to top window")
map_nav("<C-l>", "<C-w><C-l>", "Go to right window")

-- Automatically enter insert mode when a terminal opens
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Auto enter insert mode when opening a terminal",
	pattern = "term://*",
	callback = function()
		vim.cmd.startinsert()
	end,
})

-- Enable C-w navigation from the terminal
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Window command" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Delete buffer with bbye
vim.keymap.set("n", "<Leader>bd", "<Cmd>Bdelete this<CR>", { desc = "Delete buffer" })

-- Reformat paragraph
vim.keymap.set("n", "<Leader>Q", "{gq}", { desc = "Reformat paragraph" })
