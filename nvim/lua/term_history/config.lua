local M = {}

---@class term_history.Config
M.defaults = {
	max_history = 150,
	debug       = false,
}

---@type term_history.Config
M.options = vim.deepcopy(M.defaults)

---@param opts? term_history.Config
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

---@return term_history.Config
function M.get()
	return M.options
end

return M
