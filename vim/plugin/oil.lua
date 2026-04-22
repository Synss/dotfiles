local oil = require("oil")

oil.setup({
	keymaps = {
		-- Navigation
		["<C-h>"] = "<C-w><C-h>",
		["<C-j>"] = "<C-w><C-j>",
		["<C-k>"] = "<C-w><C-k>",
		["<C-l>"] = "<C-w><C-l>",
		--
		["q"] = { "actions.close", mode = "n" },
	},
})

vim.keymap.set("n", "-", function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	if buf_name ~= "" and vim.bo.buftype == "" then
		oil.open(vim.fs.dirname(buf_name))
	else
		oil.open()
	end
end, { desc = "Start Oil relative to the current file" })
