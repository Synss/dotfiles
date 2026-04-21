require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-f>"] = { "select_and_accept" },
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
})
