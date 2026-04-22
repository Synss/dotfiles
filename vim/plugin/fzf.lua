local fzf = require("fzf-lua")

local function map_fzf_split(key, cmd, label)
	vim.keymap.set("n", "<Leader>f" .. key, function()
		fzf.files({ winopts = { split = cmd } })
	end, { desc = "Find files " .. label })
end

vim.keymap.set("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ff", function()
	fzf.files({ winopts = { split = vim.api.nvim_get_current_win() } })
end, { desc = "Find files" })
vim.keymap.set("n", "<Leader>fr", "<Cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Live grep" })

map_fzf_split("h", "leftabove vnew", "left")
map_fzf_split("j", "rightbelow new", "below")
map_fzf_split("k", "leftabove new", "above")
map_fzf_split("l", "rightbelow vnew", "right")

fzf.setup({
	grep = {
		rg_opts = "--hidden --glob '!.git' --glob '!.gitmodules'",
	},
})
