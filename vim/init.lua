-- Memo: `set` -> `vim.opt`, `let` -> `vim.g`

vim.g.mapleader = " "

-- Options

vim.opt.list = true
vim.opt.listchars = { nbsp = "␣", tab = "⇥ ", trail = "·" }

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.timeoutlen = 200 -- ms to wait for mapped sequence to complete

if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	vim.opt.termguicolors = true
end

-- Splits

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

local function map_nav(key, cmd, desc)
	vim.keymap.set("n", key, cmd, { desc = desc })
	vim.keymap.set("t", key, "<C-\\><C-n>" .. cmd, { desc = desc })
end

map_nav("<C-h>", "<C-w><C-h>", "Go to left window")
map_nav("<C-j>", "<C-w><C-j>", "Go to bottom window")
map_nav("<C-k>", "<C-w><C-k>", "Go to top window")
map_nav("<C-l>", "<C-w><C-l>", "Go to right window")

-- Visual mode

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Dedent selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })

vim.keymap.set("v", "<Leader>W", function()
	local view = vim.fn.winsaveview()
	vim.cmd([['<,'>s/\s\+$//e]])
	vim.fn.winrestview(view)
end, { desc = "Remove trailing whitespace" })

-- Terminal

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Auto enter insert mode when opening a terminal",
	pattern = "term://*",
	callback = function() vim.cmd.startinsert() end,
})

vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Window command" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers

vim.keymap.set("n", "<Leader>q", "<Cmd>Bdelete! this<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "Q", "<Cmd>Bwipeout! this<CR>", { desc = "Wipeout buffer" })
vim.keymap.set("n", "gQ", "gqip", { desc = "Reformat paragraph" })
