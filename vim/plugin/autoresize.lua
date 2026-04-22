local RATIO = 5 / 4

local function equalize_heights()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local widths = {}
	for _, w in ipairs(wins) do
		if vim.api.nvim_win_get_config(w).relative == "" then
			widths[w] = vim.api.nvim_win_get_width(w)
		end
	end
	vim.cmd.wincmd("=")
	return wins, widths
end

local function column_wins(cur)
	local col = vim.api.nvim_win_get_position(cur)[2]
	local wins = {}
	for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_position(w)[2] == col
				and vim.api.nvim_win_get_config(w).relative == ""
				and vim.bo[vim.api.nvim_win_get_buf(w)].buftype ~= "quickfix"
		then
			table.insert(wins, w)
		end
	end
	return wins
end

local function resize(cur, wins)
	local fair = vim.api.nvim_win_get_height(cur)
	local focused_h = math.floor(fair * RATIO)
	local other_h = math.max(1, math.floor((fair * #wins - focused_h) / (#wins - 1)))
	vim.api.nvim_win_set_height(cur, focused_h)
	for _, w in ipairs(wins) do
		if w ~= cur then vim.api.nvim_win_set_height(w, other_h) end
	end
end

vim.api.nvim_create_autocmd("WinEnter", {
	desc = "Auto-resize focused window vertically",
	callback = function()
		if vim.api.nvim_win_get_config(0).relative ~= "" then return end
		if vim.bo.buftype == "quickfix" then return end
		local all_wins, widths = equalize_heights()
		local cur = vim.api.nvim_get_current_win()
		local wins = column_wins(cur)
		if #wins > 1 then resize(cur, wins) end
		for _, w in ipairs(all_wins) do
			if widths[w] then vim.api.nvim_win_set_width(w, widths[w]) end
		end
	end,
})
