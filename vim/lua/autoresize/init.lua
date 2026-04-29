local config = require("autoresize.config")

local M = {}

local function equalize_heights(tpwins)
	local widths = {}
	for _, w in ipairs(tpwins) do
		if vim.api.nvim_win_get_config(w).relative == "" then
			widths[w] = vim.api.nvim_win_get_width(w)
		end
	end
	vim.cmd.wincmd("=")
	return tpwins, widths
end

local function column_wins(tpwins, col)
	return vim.tbl_filter(function(w)
		return vim.api.nvim_win_get_position(w)[2] == col
				and vim.api.nvim_win_get_config(w).relative == ""
				and vim.bo[vim.api.nvim_win_get_buf(w)].buftype ~= "quickfix"
	end, tpwins)
end

local function resize(cwins, cur)
	local fair = vim.api.nvim_win_get_height(cur)
	local focused_h = math.floor(fair * config.get().ratio)
	local other_h = math.max(1, math.floor((fair * #cwins - focused_h) / (#cwins - 1)))

	vim.api.nvim_win_set_height(cur, focused_h)
	for _, w in ipairs(cwins) do
		if w ~= cur then vim.api.nvim_win_set_height(w, other_h) end
	end
end

function M.resize_handler()
	if vim.api.nvim_win_get_config(0).relative ~= "" then return end
	if vim.tbl_contains(config.get().exclude_buftypes, vim.bo.buftype) then return end
	local tpwins = vim.api.nvim_tabpage_list_wins(0)
	local all_wins, widths = equalize_heights(tpwins)
	local cur = vim.api.nvim_get_current_win()
	local cwins = column_wins(tpwins, vim.api.nvim_win_get_position(cur)[2])
	if #cwins > 1 then resize(cwins, cur) end
	for _, w in ipairs(all_wins) do
		if widths[w] then vim.api.nvim_win_set_width(w, widths[w]) end
	end
end

function M.setup(user_config)
	config.setup(user_config or {})
end

return M
