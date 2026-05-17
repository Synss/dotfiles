local br = require("mini.bufremove")

local function save()
	if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly
			and vim.api.nvim_buf_get_name(0) ~= "" then
		vim.cmd.write()
	end
end

vim.keymap.set("n", "<Leader>q", function()
	save(); br.delete(0, true)
end, { desc = "Delete buffer" })
vim.keymap.set("n", "Q", function()
	save(); br.wipeout(0, true)
end, { desc = "Wipeout buffer" })
