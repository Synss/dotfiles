local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")

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

vim.keymap.set("n", "<Leader>fb", in_current_win(fzf.buffers), { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", in_current_win(fzf.files), { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", in_current_win(fzf.oldfiles), { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", in_current_win(fzf.live_grep), { desc = "Live grep" })

vim.keymap.set("n", "<Leader>fh", fzf_in_split("leftabove vnew"), { desc = "Find files left" })
vim.keymap.set("n", "<Leader>fj", fzf_in_split("rightbelow new"), { desc = "Find files below" })
vim.keymap.set("n", "<Leader>fk", fzf_in_split("leftabove new"), { desc = "Find files above" })
vim.keymap.set("n", "<Leader>fl", fzf_in_split("rightbelow vnew"), { desc = "Find files right" })

fzf.setup({
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules' --line-number --column",
	},
})
