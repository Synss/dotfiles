-- LSP diagnostics (<leader>l* namespace; [d/]d are standard bracket navigation)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { silent = true })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { silent = true })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { silent = true })

local on_attach = function(_client, bufnr)
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

	-- gd/gD/gi/gr/K are standard vim navigation conventions — not namespaced
	local map = function(key, fn)
		vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true })
	end
	map("gD", vim.lsp.buf.declaration)
	map("gd", vim.lsp.buf.definition)
	map("K", vim.lsp.buf.hover)
	map("gi", vim.lsp.buf.implementation)
	map("gr", vim.lsp.buf.references)
	map("<leader>lD", vim.lsp.buf.type_definition)
	map("<leader>lr", vim.lsp.buf.rename)
	map("<leader>la", vim.lsp.buf.code_action)
	map("<leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end)
	map("<leader>lwa", vim.lsp.buf.add_workspace_folder)
	map("<leader>lwr", vim.lsp.buf.remove_workspace_folder)
	map("<leader>lwl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)
end

vim.lsp.config("*", { on_attach = on_attach })

local servers = {
	"ansiblels",
	"bazelrc_lsp",
	"clangd",
	"cssls",
	"gh_actions_ls",
	"lua_ls",
	"nil_ls",
	"pyright",
	"ruff",
	"starlark_rust",
}

vim.lsp.config("ansiblels", {
	filetypes = { "yaml.ansible" },
})

vim.lsp.config("gh_actions_ls", {
	filetypes = { "yaml.github" },
	root_markers = { ".github" },
})

-- Run `nixfmt` on save
vim.lsp.config("nil_ls", {
	settings = {
		["nil"] = {
			formatting = { command = { "nixfmt" } },
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

-- Point pyright at the uv-managed venv (.venv in project root).
vim.lsp.config("pyright", {
	settings = {
		python = {
			venvPath = ".",
			venv = ".venv",
		},
	},
})

-- Make sure both plugins are loaded in the correct order.
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false,
})

for _, lsp in pairs(servers) do
	vim.lsp.enable(lsp)
end
