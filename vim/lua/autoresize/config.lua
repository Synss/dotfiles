local M = {}

M.defaults = {
	ratio = 5 / 4
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.get()
	return M.options
end

return M
