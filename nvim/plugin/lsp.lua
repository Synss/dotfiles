local lsp = require("lsp")

vim.lsp.log.set_level("error")

-- Enable LSPs

vim.lsp.enable(
	{
		"ansiblels",   -- ansible-language-server
		"basedpyright", -- basedpyright
		"clangd",      -- clang-tools
		"groovyls",    -- groovy-language-server
		"cssls",       -- vscode-langservers-extracted
		"eslint",      -- vscode-langservers-extracted
		"gh_actions_ls", -- actions-languageserver
		"html",        -- vscode-langservers-extracted
		"jsonls",      -- vscode-langservers-extracted
		"lua_ls",      -- lua-language-server
		"marksman",    -- marksman
		"nil_ls",      -- nil
		"nixd",        -- nixd
		"ruff",        -- ruff
		"starpls",     -- starpls
		"typos_lsp",   -- typos-lsp
		"yamlls",      -- yaml-language-server
	})

-- Diagnostics

vim.keymap.set("n", "<Leader>ld", vim.diagnostic.open_float, { silent = true, desc = "Show diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<Leader>lq", vim.diagnostic.setloclist, { silent = true, desc = "Diagnostics to loclist" })

-- Codelens

vim.keymap.set("n", "<Leader>lc", function()
	vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
end, { silent = true, desc = "Toggle codelens" })

-- Config

-- Disable per buffer with: lua vim.b.format_on_save = false
-- Re-enable with:          lua vim.b.format_on_save = nil
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		if vim.b.format_on_save == false then return end
		vim.lsp.buf.format({ async = false }) -- must complete before the write
	end,
	desc = "Format on write",
})

vim.lsp.config("*", {
	on_attach = lsp.on_attach,
	capabilities = lsp.capabilities,
})
