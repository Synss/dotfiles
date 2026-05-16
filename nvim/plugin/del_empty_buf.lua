vim.api.nvim_create_autocmd("BufHidden", {
	desc = "Delete empty, unnamed buffers when they are hidden",
	callback = function(event)
		if vim.api.nvim_buf_get_name(event.buf) == ""
				and vim.api.nvim_get_option_value("buftype", { buf = event.buf }) == ""
				and vim.api.nvim_buf_get_offset(event.buf, vim.api.nvim_buf_line_count(event.buf)) <= 1
		then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(event.buf) then
					vim.api.nvim_buf_delete(event.buf, { force = true })
				end
			end)
		end
	end,
})
