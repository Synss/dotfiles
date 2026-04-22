local fzf = require("fzf-lua")

local function in_current_win(picker)
	return function()
		picker({ winopts = { split = vim.api.nvim_get_current_win() } })
	end
end

local function map_fzf_split(key, cmd, label)
	vim.keymap.set("n", "<Leader>f" .. key, function()
		fzf.files({ winopts = { split = cmd } })
	end, { desc = "Find files " .. label })
end

vim.keymap.set("n", "<Leader>fb", in_current_win(fzf.buffers), { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", in_current_win(fzf.files), { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", in_current_win(fzf.oldfiles), { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", in_current_win(fzf.live_grep), { desc = "Live grep" })

map_fzf_split("h", "leftabove vnew", "left")
map_fzf_split("j", "rightbelow new", "below")
map_fzf_split("k", "leftabove new", "above")
map_fzf_split("l", "rightbelow vnew", "right")

fzf.setup({
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules' --line-number --column",
	},
})
