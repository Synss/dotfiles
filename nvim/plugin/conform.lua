local conform = require("conform")

conform.setup({
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = {
		json = { "prettier", lsp_format = "never" },
	},
})

vim.keymap.set("n", "<Leader>lf", function()
	conform.format({ async = true })
end, { silent = true, desc = "Format" })
