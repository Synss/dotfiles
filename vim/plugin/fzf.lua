local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local fzf_config = require("fzf-lua.config")

local function in_current_win(picker)
	return function()
		picker({ winopts = { split = vim.api.nvim_get_current_win() } })
	end
end

local function fzf_in_split(split_cmd)
	return function()
		vim.cmd(split_cmd)
		local win = vim.api.nvim_get_current_win()
		fzf.files({
			winopts = { split = win },
			actions = {
				["default"] = function(selected, opts)
					if selected and #selected > 0 then
						vim.api.nvim_set_current_win(win)
						fzf_actions.file_edit(selected, opts)
					elseif vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
					end
				end,
			},
		})
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

vim.keymap.set("n", "<Leader>fb", in_current_win(fzf.buffers), { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", smart_find, { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", in_current_win(fzf.oldfiles), { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", in_current_win(fzf.live_grep), { desc = "Live grep" })

vim.keymap.set("n", "<Leader>fh", fzf_in_split("leftabove vnew"), { desc = "Find files left" })
vim.keymap.set("n", "<Leader>fj", fzf_in_split("rightbelow new"), { desc = "Find files below" })
vim.keymap.set("n", "<Leader>fk", fzf_in_split("leftabove new"), { desc = "Find files above" })
vim.keymap.set("n", "<Leader>fl", fzf_in_split("rightbelow vnew"), { desc = "Find files right" })

fzf.setup({
	files = { fd_opts = "--color=never --type f --hidden --follow --exclude .git" },
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules' --line-number --column",
	},
})
