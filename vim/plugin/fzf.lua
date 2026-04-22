vim.keymap.set("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", "<Cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Live grep" })

require("fzf-lua").setup({
	files = {
		winopts = { split = "belowright new" },
	},
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
	},
})
