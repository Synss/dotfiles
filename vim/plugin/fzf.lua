vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", ":FzfLua oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>", { desc = "Live grep" })

require("fzf-lua").setup({
	files = {
		cmd = "fd --type f --hidden --exclude .git --exclude .gitmodules",
		winopts = { split = "belowright new" },
	},
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
	},
})
