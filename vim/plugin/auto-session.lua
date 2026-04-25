local startup_cwd = vim.fn.getcwd()

require("auto-session").setup({
	purge_after_minutes = 43200, -- min, or 30 days
	legacy_cmds = false,
	pre_save_cmds = {
		-- Save session from the path nvim started
		function() vim.cmd.cd(startup_cwd) end,
	},
	session_lens = {
		picker      = "fzf",
		previewer   = "active_buffer", -- or "summary"
		picker_opts = {
			preview = { hidden = false },
		},
	},
})
