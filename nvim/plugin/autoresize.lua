vim.api.nvim_create_autocmd("WinEnter", {
	desc = "Auto-resize focused window vertically",
	callback = function()
		require("autoresize").resize_handler()
	end,
})
