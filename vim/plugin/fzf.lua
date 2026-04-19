vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>ff", ":FzfLua oldfiles<CR>")
vim.keymap.set("n", "<leader>g", ":FzfLua live_grep<CR>")

require("fzf-lua").setup({
	files = {
		cmd = "fd --type f --hidden --exclude .git --exclude .gitmodules",
	},
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
	},
})
