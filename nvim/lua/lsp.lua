local blink_cmp = require("blink.cmp")
local fzf_lua = require("fzf-lua")

local M = {}

M.capabilities = blink_cmp.get_lsp_capabilities({
	general = {
		positionEncodings = { "utf-8" },
	},
})

M.on_attach = function(_client, bufnr)
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Navigation
	map("gd", vim.lsp.buf.declaration, "Go to declaration")
	map("gD", vim.lsp.buf.definition, "Go to definition")
	map("gi", fzf_lua.lsp_implementations, "Go to implementation")
	map("gr", fzf_lua.lsp_references, "References")

	-- Information
	map("K", function()
		local diagnostics =
				vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
		if #diagnostics > 0 then
			vim.diagnostic.open_float()
		else
			vim.lsp.buf.hover()
		end
	end, "Diagnostic / hover")
	map("<Leader>lD", vim.lsp.buf.type_definition, "Type definition")

	-- Actions
	map("<Leader>lr", vim.lsp.buf.rename, "Rename")
	map("<Leader>la", fzf_lua.lsp_code_actions, "Code action")
	map("<Leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format")

	-- Workspace
	map("<Leader>lW", fzf_lua.lsp_workspace_diagnostics, "Workspace diagnostics")
	map("<Leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
	map("<Leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
	map("<Leader>lwl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List workspace folders")
end

return M
