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

vim.opt.scrolloff = 4

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.exrc = true
vim.opt.timeoutlen = 200 -- ms to wait for mapped sequence to complete

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	vim.opt.termguicolors = true
end

-- Search

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Leader>/", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Splits

vim.keymap.set("n", "<Leader>sh", "<Cmd>leftabove vnew<CR>", { desc = "Split left" })
vim.keymap.set("n", "<Leader>sj", "<Cmd>rightbelow new<CR>", { desc = "Split below" })
vim.keymap.set("n", "<Leader>sk", "<Cmd>leftabove new<CR>", { desc = "Split above" })
vim.keymap.set("n", "<Leader>sl", "<Cmd>rightbelow vnew<CR>", { desc = "Split right" })
vim.keymap.set("n", "<Leader>sH", "<Cmd>topleft vnew<CR>", { desc = "Split far left" })
vim.keymap.set("n", "<Leader>sJ", "<Cmd>botright new<CR>", { desc = "Split far bottom" })
vim.keymap.set("n", "<Leader>sK", "<Cmd>topleft new<CR>", { desc = "Split far top" })
vim.keymap.set("n", "<Leader>sL", "<Cmd>botright vnew<CR>", { desc = "Split far right" })

local function map_nav(key, dir, desc)
	vim.keymap.set("n", key, function()
		if vim.api.nvim_win_get_config(0).relative ~= "" then return end
		vim.cmd.wincmd(dir)
	end, { desc = desc })
	vim.keymap.set("t", key, "<C-\\><C-n><C-w><C-" .. dir .. ">", { desc = desc })
end

map_nav("<C-h>", "h", "Go to left window")
map_nav("<C-j>", "j", "Go to bottom window")
map_nav("<C-k>", "k", "Go to top window")
map_nav("<C-l>", "l", "Go to right window")

-- Windows

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
	callback = function()
		if vim.bo.buftype == "" then
			vim.wo.number = true
			vim.wo.relativenumber = true
			vim.wo.cursorline = true
			vim.wo.cursorlineopt = "number"
		end
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.cursorline = false
	end,
})

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorline = true
vim.wo.cursorlineopt = "number"

-- Visual mode

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Dedent selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })

vim.keymap.set("n", "<Leader>W", function()
	local view = vim.fn.winsaveview()
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.winrestview(view)
end, { desc = "Remove trailing whitespace" })
vim.keymap.set("v", "<Leader>W", function()
	local view = vim.fn.winsaveview()
	vim.cmd([['<,'>s/\s\+$//e]])
	vim.fn.winrestview(view)
end, { desc = "Remove trailing whitespace" })

-- Terminal

vim.keymap.set("n", "<Leader>t", "<Cmd>terminal<CR>", { desc = "Terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function() vim.wo.scrolloff = 0 end,
})

vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Window command" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers

vim.keymap.set("n", "q:", "<Nop>", { desc = "Disable command-line window" })
vim.keymap.set("n", "q/", "<Nop>", { desc = "Disable command-line search window (forward)" })
vim.keymap.set("n", "q?", "<Nop>", { desc = "Disable command-line search window (backward)" })

local function save()
	if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly
			and vim.api.nvim_buf_get_name(0) ~= "" then
		vim.cmd.write()
	end
end

vim.keymap.set("n", "<Leader>q", function()
	save(); vim.cmd("Bdelete! this")
end, { desc = "Delete buffer" })
vim.keymap.set("n", "Q", function()
	save(); vim.cmd("Bwipeout! this")
end, { desc = "Wipeout buffer" })

-- Clipboard

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+P', { desc = "Paste before from clipboard" })
