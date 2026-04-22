vim.lsp.log.set_level("error")

-- LSP diagnostics (<Leader>l* namespace; [d/]d are standard bracket navigation)
vim.keymap.set("n", "<Leader>ld", vim.diagnostic.open_float, { silent = true, desc = "Show diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<Leader>lq", vim.diagnostic.setloclist, { silent = true, desc = "Diagnostics to loclist" })

local on_attach = function(_client, bufnr)
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

	-- gd/gD/gi/gr/K are standard vim navigation conventions — not namespaced
	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true, desc = desc })
	end
	map("gD", vim.lsp.buf.declaration, "Go to declaration")
	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("K", vim.lsp.buf.hover, "Hover")
	map("gi", vim.lsp.buf.implementation, "Go to implementation")
	map("gr", vim.lsp.buf.references, "References")
	map("<Leader>lD", vim.lsp.buf.type_definition, "Type definition")
	map("<Leader>lr", vim.lsp.buf.rename, "Rename")
	map("<Leader>la", vim.lsp.buf.code_action, "Code action")
	map("<Leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format")
	map("<Leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
	map("<Leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
	map("<Leader>lwl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List workspace folders")
end

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = false }) -- must complete before the write
	end,
})

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = {
		general = {
			positionEncodings = { "utf-8" },
		},
	},
})

local servers = {
	-- See `:checkhealth vim.lsp`.
	"ansiblels",           -- ansible-language-server
	"clangd",              -- clang-tools
	"groovyls",            -- groovy-language-server
	"cssls",               -- vscode-langservers-extracted
	"eslint",              -- vscode-langservers-extracted
	"gh_actions_ls",       -- actions-languageserver
	"html",                -- vscode-langservers-extracted
	"jsonls",              -- vscode-langservers-extracted
	"lua_ls",              -- lua-language-server
	"marksman",            -- marksman
	"nil_ls",              -- nil_ls
	"pyright",             -- pyright
	"ruff",                -- ruff
	"starlark_rust",       -- starlark-rust
	"yaml-language-server", -- yaml-language-server
}

vim.lsp.config("ansiblels", {
	filetypes = { "yaml.ansible" },
})

vim.lsp.config("gh_actions_ls", {
	cmd = { "actions-languageserver", "--stdio" },
	filetypes = { "yaml.github" },
	root_markers = { ".github" },
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

vim.lsp.config("nil_ls", {
	settings = {
		["nil"] = {
			formatting = { command = { "nixfmt" } },
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

vim.lsp.config("starlark_rust", {
	filetypes = { "bzl" },
})

vim.lsp.config("yaml-language-server", {})

for _, lsp in pairs(servers) do
	vim.lsp.enable(lsp)
end
