local oil = require("oil")

oil.setup({
	keymaps = {
		-- Navigation
		["<C-H>"] = "<C-W><C-H>",
		["<C-J>"] = "<C-W><C-J>",
		["<C-K>"] = "<C-W><C-K>",
		["<C-L>"] = "<C-W><C-L>",
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
