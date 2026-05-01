local M = {}

---@class autoresize.Config
---@field ratio number Height ratio for the focused window (default: 1.25)
---@field exclude_buftypes string[] Buffer types excluded from resizing
M.defaults = {
	ratio = 5 / 4,
	exclude_buftypes = { "quickfix" },
}

---@type autoresize.Config
M.options = vim.deepcopy(M.defaults)

---@param opts? autoresize.Config
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

---@return autoresize.Config
function M.get()
	return M.options
end

return M
