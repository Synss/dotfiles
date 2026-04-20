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

require("session")

-- Case insensitive matching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false
vim.opt.swapfile = false

-- Color scheme
if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
	vim.opt.termguicolors = true
end

require("theme")

-- Split creation (<leader>w* namespace; uppercase = full-edge split)
vim.keymap.set("n", "<leader>wh", ":leftabove vnew<cr>", { desc = "Split left" })
vim.keymap.set("n", "<leader>wj", ":rightbelow new<cr>", { desc = "Split below" })
vim.keymap.set("n", "<leader>wk", ":leftabove new<cr>", { desc = "Split above" })
vim.keymap.set("n", "<leader>wl", ":rightbelow vnew<cr>", { desc = "Split right" })

vim.keymap.set("n", "<leader>wH", ":topleft vnew<cr>", { desc = "Split far left" })
vim.keymap.set("n", "<leader>wJ", ":botright new<cr>", { desc = "Split far bottom" })
vim.keymap.set("n", "<leader>wK", ":topleft new<cr>", { desc = "Split far top" })
vim.keymap.set("n", "<leader>wL", ":botright vnew<cr>", { desc = "Split far right" })

-- Enable C-W navigation from the terminal
vim.keymap.set("t", "<C-W>", "<C-\\><C-n><C-W>", { desc = "Window command" })

-- Delete buffer with bbye
vim.keymap.set("n", "<leader>bd", ":Bdelete this<CR>", { desc = "Delete buffer" })

-- Reformat paragraph
vim.keymap.set("n", "<leader>Q", "{gq}", { desc = "Reformat paragraph" })
