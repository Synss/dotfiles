vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "roles/**/*.yml" },
	callback = function()
		vim.bo.filetype = "yaml.ansible"
	end,
})
