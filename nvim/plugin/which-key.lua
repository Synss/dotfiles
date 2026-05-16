local nerdy = require("nerdy.fetcher")
local wk = require("which-key")

-- Do not underline icons
vim.api.nvim_set_hl(0, "WhichKeyIcon", { link = "WhichKeyIconGrey" })

wk.setup()
wk.add({
	-- Clipboard
	{ "<Leader>p", icon = { icon = nerdy.get("md-content_paste"), color = "cyan" } },
	{ "<Leader>P", icon = { icon = nerdy.get("md-content_paste"), color = "cyan" } },
	{ "<Leader>y", icon = { icon = nerdy.get("md-content_copy"), color = "cyan" } },
	-- Search
	{ "<Leader>/", icon = { icon = nerdy.get("md-magnify_close"), color = "green" } },
	-- Splits
	{
		"<Leader>s",
		group = "Splits",
		icon = { icon = nerdy.get("cod-split_horizontal"), color = "red" },
	},
	{ "<Leader>sh", icon = { icon = nerdy.get("cod-split_horizontal"), color = "blue" } },
	{ "<Leader>sl", icon = { icon = nerdy.get("cod-split_horizontal"), color = "blue" } },
	{ "<Leader>sj", icon = { icon = nerdy.get("cod-split_vertical"), color = "blue" } },
	{ "<Leader>sk", icon = { icon = nerdy.get("cod-split_vertical"), color = "blue" } },
	{ "<Leader>sH", icon = { icon = nerdy.get("cod-layout_sidebar_left_off"), color = "blue" } },
	{ "<Leader>sL", icon = { icon = nerdy.get("cod-layout_sidebar_right_off"), color = "blue" } },
	{ "<Leader>sJ", icon = { icon = nerdy.get("cod-layout_panel_off"), color = "blue" } },
	{ "<Leader>sK", icon = { icon = nerdy.get("cod-split_vertical"), color = "blue" } },
	-- Text
	{ "<Leader>W",  icon = { icon = nerdy.get("cod-whitespace"), color = "grey" } },
})
