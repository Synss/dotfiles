local nerdy = require("nerdy.fetcher")

local mode = {
	icons = {
		win = nerdy.get("md-window_maximize"), -- Normal
		pen = nerdy.get("oct-pencil"), -- Insert
		sel = nerdy.get("md-selection_drag"), -- Visual/Select
		cmd = nerdy.get("oct-terminal"), -- Command
		rep = nerdy.get("md-cached"), -- Replace
	},
}

mode.map = {
	n = mode.icons.win,
	i = mode.icons.pen,
	c = mode.icons.cmd,
	R = mode.icons.rep,
	t = mode.icons.cmd,
	v = mode.icons.sel,
	V = mode.icons.sel,
	["\22"] = mode.icons.sel,
	s = mode.icons.sel,
	S = mode.icons.sel,
	["\19"] = mode.icons.sel,
}

local diff = {
	symbols = {
		added = nerdy.get("md-git") .. nerdy.get("md-plus"),
		modified = nerdy.get("md-git") .. nerdy.get("md-pencil"),
		removed = nerdy.get("md-git") .. nerdy.get("md-minus"),
	},
}

local filename = {
	symbols = {
		modified = nerdy.get("md-content_save_edit"),
		readonly = nerdy.get("md-lock"),
		unnamed = "[No Name]",
	},
}

local diagnostics = {
	"diagnostics",
	symbols = {
		error = nerdy.get("md-close_circle") .. " ",
		warn = nerdy.get("md-alert") .. " ",
		info = nerdy.get("md-information") .. " ",
		hint = nerdy.get("md-lightbulb_outline") .. " ",
	},
	colored = true,
}

require("lualine").setup({
	options = {
		theme = "auto",
		icons_enabled = true,
		component_separator = "",
		section_separator = {
			left = nerdy.get("pl-left_hard_divider"),
			right = nerdy.get("pl-right_hard_divider"),
		},
	},
	sections = {
		lualine_a = {
			{
				function()
					return mode.map[vim.api.nvim_get_mode().mode] or mode.icons.win
				end,
				padding = { left = 1, right = 1 },
			},
		},
		lualine_b = {
			{
				"filename",
				file_status = true,
				symbols = filename.symbols,
			},
			{ "diff", symbols = diff.symbols },
		},
		lualine_c = {},
		lualine_x = {
			diagnostics,
		},
		lualine_y = { "filetype" },
		lualine_z = { "location", "progress" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {
			{
				"filename",
				path = 1,
				file_status = true,
				symbols = filename.symbols,
			},
			{ "diff", symbols = diff.symbols },
		},
		lualine_c = {},
		lualine_x = {
			diagnostics,
		},
		lualine_y = { "filetype" },
		lualine_z = { "progress" },
	},
})
