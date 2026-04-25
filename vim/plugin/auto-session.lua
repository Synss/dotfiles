require("auto-session").setup({
	purge_after_minutes = 43200, -- min, or 30 days
	legacy_cmds = false,
	session_lens = {
		picker      = "fzf",
		previewer   = "active_buffer", -- or "summary"
		picker_opts = {
			preview = { hidden = false },
		},
	},
})
