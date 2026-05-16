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
	"nil_ls",       -- nil_ls
	"ruff",         -- ruff
	"starpls",      -- starpls
	"typos_lsp",    -- typos-lsp
	"yamlls",       -- yaml-language-server
}

for _, lsp in ipairs(servers) do
	vim.lsp.enable(lsp)
end

-- LSP config

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
	local fzf_lua = require("fzf-lua")

	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true, desc = desc })
	end
	map("gd", vim.lsp.buf.declaration, "Go to declaration")
	map("gD", vim.lsp.buf.definition, "Go to definition")
	map("K", function()
		local diagnostics =
				vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
		if #diagnostics > 0 then
			vim.diagnostic.open_float()
		else
			vim.lsp.buf.hover()
		end
	end, "Diagnostic / hover")
	map("gi", fzf_lua.lsp_implementations, "Go to implementation")
	map("gr", fzf_lua.lsp_references, "References")
	map("<Leader>lD", vim.lsp.buf.type_definition, "Type definition")
	map("<Leader>lr", vim.lsp.buf.rename, "Rename")
	map("<Leader>la", function()
		fzf_lua.lsp_code_actions {
			winopts = {
				relative = "cursor",
				width = 0.5,
				height = 0.6,
				row = 1, -- bottom
				preview = { vertical = "up:65%" },
			}
		}
	end, "Code action")
	map("<Leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format")
	map("<Leader>lW", fzf_lua.lsp_workspace_diagnostics, "Workspace diagnostics")
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
	desc = "Format on write",
})

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = require("blink.cmp").get_lsp_capabilities({
		general = {
			positionEncodings = { "utf-8" },
		},
	}),
})

-- Config overrides

vim.lsp.config("ansiblels", {
	filetypes = { "yaml.ansible" },
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				venvPath = ".",
				venv = ".venv",
			},
		},
	},
})

vim.lsp.config("gh_actions_ls", {
	cmd = { "actions-languageserver", "--stdio" },
	filetypes = { "yaml.github" },
	root_markers = { ".github" },
})

vim.lsp.config("groovyls", {
	cmd = { "groovy-language-server" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			diagnostics = {
				unusedLocalExclude = { "_*" },
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


vim.lsp.config("yamlls", {
	settings = {
		-- Disable formatting by default, prefer yamlfmt
		yaml = {
			format = { enable = false }
		}
	},
})
