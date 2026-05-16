vim.lsp.log.set_level("error")

-- Enable language servers

local servers = {
	"ansiblels",    -- ansible-language-server
	"basedpyright", -- basedpyright
	"clangd",       -- clang-tools
	"groovyls",     -- groovy-language-server
	"cssls",        -- vscode-langservers-extracted
	"eslint",       -- vscode-langservers-extracted
	"gh_actions_ls", -- actions-languageserver
	"html",         -- vscode-langservers-extracted
	"jsonls",       -- vscode-langservers-extracted
	"lua_ls",       -- lua-language-server
	"marksman",     -- marksman
	"nil_ls",       -- nil
	"nixd",         -- nixd
	"ruff",         -- ruff
	"starpls",      -- starpls
	"typos_lsp",    -- typos-lsp
	"yamlls",       -- yaml-language-server
}

for _, lsp in ipairs(servers) do
	vim.lsp.enable(lsp)
end

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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.refresh()
			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				buffer = args.buf,
				callback = function() vim.lsp.codelens.refresh() end,
			})
		end
	end,
	desc = "Refresh codelens on attach",
})

-- Config

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = false }) -- must complete before the write
	end,
	desc = "Format on write",
})

local lsp = require("lsp")

vim.lsp.config("*", {
	on_attach = lsp.on_attach,
	capabilities = lsp.capabilities,
})
