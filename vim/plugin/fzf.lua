local fzf = require("fzf-lua")
local fzf_config = require("fzf-lua.config")

local function in_current_win(picker)
	return function()
		picker({ winopts = { split = vim.api.nvim_get_current_win() } })
	end
end

local function smart_find()
	-- https://github.com/ibhagwan/fzf-lua/discussions/1483
	local bufs = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name ~= "" then
				local info = vim.fn.getbufinfo(bufnr)[1]
				table.insert(bufs, {
					name = vim.fn.fnamemodify(name, ":~:."),
					lastused = info and info.lastused or 0,
				})
			end
		end
	end
	table.sort(bufs, function(a, b) return a.lastused > b.lastused end)

	local names = vim.tbl_map(function(b) return vim.fn.shellescape(b.name) end, bufs)
	local cmd = "{ "
			.. (#names > 0 and ("printf '%s\\n' " .. table.concat(names, " ") .. "; ") or "")
			.. "fd " .. fzf_config.globals.files.fd_opts .. "; } | awk '!seen[$0]++'"

	fzf.files({
		cmd = cmd,
		fzf_opts = { ["--tiebreak"] = "index" },
		winopts = { split = vim.api.nvim_get_current_win() },
	})
end

vim.keymap.set("n", "<Leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", smart_find, { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", in_current_win(fzf.live_grep), { desc = "Live grep" })

fzf.setup({
	files = { fd_opts = "--color=never --type f --hidden --follow --exclude .git" },
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules' --line-number --column",
	},
})
