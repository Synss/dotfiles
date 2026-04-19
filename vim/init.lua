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
if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	vim.opt.termguicolors = true
end

require("theme")

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

-- Delete buffer with bbye
vim.keymap.set("n", "<leader>bd", ":Bdelete this<CR>")

-- Reformat paragraph
vim.keymap.set("n", "<leader>Q", "{gq}")
