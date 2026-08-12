local startup_cwd = vim.fn.getcwd()

-- Sessions otherwise accumulate every buffer ever opened; keep only what's
-- visible in a window or is a window's alternate buffer.
local function prune_hidden_buffers()
	local keep = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			keep[vim.api.nvim_win_get_buf(win)] = true
			local alt = vim.api.nvim_win_call(win, function() return vim.fn.bufnr("#") end)
			if alt > 0 then keep[alt] = true end
		end
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if not keep[buf] and vim.bo[buf].buflisted and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end

require("auto-session").setup({
	purge_after_minutes = 43200, -- min, or 30 days
	legacy_cmds = false,
	pre_save_cmds = {
		-- Save session from the path nvim started
		function() vim.cmd.cd(startup_cwd) end,
		prune_hidden_buffers,
	},
	session_lens = {
		picker      = "fzf",
		previewer   = "active_buffer", -- or "summary"
		picker_opts = {
			preview = { hidden = false },
		},
	},
})
