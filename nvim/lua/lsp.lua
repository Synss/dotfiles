local fzf_lua = require("fzf-lua")

local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.general = { positionEncodings = { "utf-8" } }

M.on_attach = function(client, bufnr)
	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Autocompletion
	vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

	-- Navigation
	map("gd", fzf_lua.lsp_definitions, "Go to definition")
	map("gD", fzf_lua.lsp_declarations, "Go to declaration")
	map("gri", fzf_lua.lsp_implementations, "Go to implementation")
	map("grr", fzf_lua.lsp_references, "References")

	-- Information
	map("grt", fzf_lua.lsp_typedefs, "Type definition")

	-- Actions
	map("gra", fzf_lua.lsp_code_actions, "Code action")
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
