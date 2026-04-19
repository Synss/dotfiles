vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>fr", ":FzfLua oldfiles<CR>") -- r = recent
vim.keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>")

require("fzf-lua").setup({
	files = {
		cmd = "fd --type f --hidden --exclude .git --exclude .gitmodules",
	},
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
	},
})
