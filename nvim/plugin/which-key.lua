local nerdy = require("nerdy.fetcher")
local wk = require("which-key")

local function icon(name, color)
	return { icon = nerdy.get(name), color = color }
end

-- Do not underline icons
vim.api.nvim_set_hl(0, "WhichKeyIcon", { link = "WhichKeyIconGrey" })

wk.setup()
wk.add({
	{
		-- Clipboard
		{ "<Leader>p", icon = icon("md-content_paste", "cyan") },
		{ "<Leader>P", icon = icon("md-content_paste", "cyan") },
		{ "<Leader>y", icon = icon("md-content_copy", "cyan") },
	},
	{
		-- Search
		{ "<Leader>/", icon = icon("md-magnify_close", "green") },
	},
	{
		-- Splits
		{
			"<Leader>s",
			group = "Splits",
			icon = icon("cod-split_horizontal", "red"),
		},
		{ "<Leader>sh", icon = icon("cod-split_horizontal", "blue") },
		{ "<Leader>sl", icon = icon("cod-split_horizontal", "blue") },
		{ "<Leader>sj", icon = icon("cod-split_vertical", "blue") },
		{ "<Leader>sk", icon = icon("cod-split_vertical", "blue") },
		{ "<Leader>sH", icon = icon("cod-layout_sidebar_left_off", "blue") },
		{ "<Leader>sL", icon = icon("cod-layout_sidebar_right_off", "blue") },
		{ "<Leader>sJ", icon = icon("cod-layout_panel_off", "blue") },
		{ "<Leader>sK", icon = icon("cod-split_vertical", "blue") },
	},
	{
		-- Text
		{ "<Leader>W", icon = icon("cod-whitespace", "grey") },
	},
	{
		-- LSP
		{ "<Leader>lc", icon = icon("cod-eye", "cyan") },
		{ "grt",        icon = icon("cod-symbol_class", "blue") },
	},
	{
		-- Diagnostic
		icon = icon("md-stethoscope", "orange"),
		{ "[d", },
		{ "]d", },
		{ "[D", },
		{ "]D", }
	},
	{
		-- Quickfix
		icon = icon("cod-checklist", "yellow"),
		{ "[q" },
		{ "]q" },
		{ "[Q" },
		{ "]Q" },
	},
	{
		-- Location list
		icon = icon("md-format_list_bulleted", "yellow"),
		{ "[l" },
		{ "]l" },
		{ "[L" },
		{ "]L" },
	},
	{
		-- Buffers
		icon = icon("md-file_multiple", "cyan"),
		{ "[b" },
		{ "]b" },
		{ "[B" },
		{ "]B" },
	},
	{
		-- Tabs
		icon = icon("md-tab", "purple"),
		{ "[t" },
		{ "]t" },
		{ "[T" },
		{ "]T" },
	},
	{
		-- Shell prompts (OSC 133)
		icon = icon("md-console_line", "green"),
		{ "[[" },
		{ "]]" },
	},
	{
		-- Blank lines
		icon = icon("md-format_line_spacing", "grey"),
		{ "[<Space>" },
		{ "]<Space>" },
	},
	{
		-- Methods
		icon = icon("md-function", "blue"),
		{ "[m" },
		{ "]m" },
		{ "[M" },
		{ "]M" },
	},
	{
		-- Spelling
		icon = icon("md-spellcheck", "red"),
		{ "[s" },
		{ "]s" },
	},
	{
		-- Brackets
		{ "[(", icon = icon("md-code_parentheses", "grey") },
		{ "](", icon = icon("md-code_parentheses", "grey") },
		{ "[{", icon = icon("md-code_brackets", "grey") },
		{ "]{", icon = icon("md-code_brackets", "grey") },
		{ "[%", icon = icon("md-code_brackets", "grey") },
		{ "]%", icon = icon("md-code_brackets", "grey") },
	},
})
