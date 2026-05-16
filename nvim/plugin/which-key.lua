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
	-- LSP navigation
	{ "grt", icon = { icon = nerdy.get("cod-symbol_class"), color = "blue" } },
	-- Diagnostic
	{ "[d",         icon = { icon = nerdy.get("md-stethoscope"), color = "orange" } },
	{ "]d",         icon = { icon = nerdy.get("md-stethoscope"), color = "orange" } },
	{ "[D",         icon = { icon = nerdy.get("md-stethoscope"), color = "orange" } },
	{ "]D",         icon = { icon = nerdy.get("md-stethoscope"), color = "orange" } },
	-- Quickfix
	{ "[q",         icon = { icon = nerdy.get("cod-checklist"), color = "yellow" } },
	{ "]q",         icon = { icon = nerdy.get("cod-checklist"), color = "yellow" } },
	{ "[Q",         icon = { icon = nerdy.get("cod-checklist"), color = "yellow" } },
	{ "]Q",         icon = { icon = nerdy.get("cod-checklist"), color = "yellow" } },
	-- Location list
	{ "[l",         icon = { icon = nerdy.get("md-format_list_bulleted"), color = "yellow" } },
	{ "]l",         icon = { icon = nerdy.get("md-format_list_bulleted"), color = "yellow" } },
	{ "[L",         icon = { icon = nerdy.get("md-format_list_bulleted"), color = "yellow" } },
	{ "]L",         icon = { icon = nerdy.get("md-format_list_bulleted"), color = "yellow" } },
	-- Buffers
	{ "[b",         icon = { icon = nerdy.get("md-file_multiple"), color = "cyan" } },
	{ "]b",         icon = { icon = nerdy.get("md-file_multiple"), color = "cyan" } },
	{ "[B",         icon = { icon = nerdy.get("md-file_multiple"), color = "cyan" } },
	{ "]B",         icon = { icon = nerdy.get("md-file_multiple"), color = "cyan" } },
	-- Tabs
	{ "[t",         icon = { icon = nerdy.get("md-tab"), color = "purple" } },
	{ "]t",         icon = { icon = nerdy.get("md-tab"), color = "purple" } },
	{ "[T",         icon = { icon = nerdy.get("md-tab"), color = "purple" } },
	{ "]T",         icon = { icon = nerdy.get("md-tab"), color = "purple" } },
	-- Shell prompts (OSC 133)
	{ "[[",         icon = { icon = nerdy.get("md-console_line"), color = "green" } },
	{ "]]",         icon = { icon = nerdy.get("md-console_line"), color = "green" } },
	-- Blank lines
	{ "[<Space>",   icon = { icon = nerdy.get("md-format_line_spacing"), color = "grey" } },
	{ "]<Space>",   icon = { icon = nerdy.get("md-format_line_spacing"), color = "grey" } },
	-- Methods
	{ "[m",         icon = { icon = nerdy.get("md-function"), color = "blue" } },
	{ "]m",         icon = { icon = nerdy.get("md-function"), color = "blue" } },
	{ "[M",         icon = { icon = nerdy.get("md-function"), color = "blue" } },
	{ "]M",         icon = { icon = nerdy.get("md-function"), color = "blue" } },
	-- Spelling
	{ "[s",         icon = { icon = nerdy.get("md-spellcheck"), color = "red" } },
	{ "]s",         icon = { icon = nerdy.get("md-spellcheck"), color = "red" } },
	-- Brackets
	{ "[(",         icon = { icon = nerdy.get("md-code_parentheses"), color = "grey" } },
	{ "](",         icon = { icon = nerdy.get("md-code_parentheses"), color = "grey" } },
	{ "[{",         icon = { icon = nerdy.get("md-code_brackets"), color = "grey" } },
	{ "]{",         icon = { icon = nerdy.get("md-code_brackets"), color = "grey" } },
	{ "[%",         icon = { icon = nerdy.get("md-code_brackets"), color = "grey" } },
	{ "]%",         icon = { icon = nerdy.get("md-code_brackets"), color = "grey" } },
})
