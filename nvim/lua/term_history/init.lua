local config = require("term_history.config")

local M = {}

---@param opts? term_history.Config
function M.setup(opts)
	config.setup(opts)
end

local function log(msg)
	if not config.get().debug then return end
	vim.schedule(function()
		vim.notify("[TERM_DEBUG] " .. msg, vim.log.levels.DEBUG)
	end)
end

local function join_path(...)
	return table.concat({ ... }, "/")
end

local function project_hash()
	return vim.fn.sha256(vim.fn.getcwd()):sub(1, 12)
end

local base_dir = join_path(vim.fn.stdpath("state"), "session_term")

local state = {
	history_dir    = join_path(base_dir, project_hash()),
	last_save_time = 0,
	restore_idx    = 0,
}

---@return {idx: integer, lines: string[]}[]
local function collect_terminals()
	local entries  = {}
	local term_idx = 0

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			term_idx = term_idx + 1
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

			while #lines > 0 and lines[#lines]:match("^%s*$") do
				lines[#lines] = nil
			end

			if #lines > config.get().max_history then
				lines = vim.list_slice(lines, #lines - config.get().max_history + 1)
			end

			table.insert(entries, { idx = term_idx, lines = lines })
		end
	end

	return entries
end

---@param path string
---@param content string
local function write_async(path, content)
	vim.uv.fs_open(path, "w", 0x1A4, function(err, fd)
		if err or not fd then return end
		vim.uv.fs_write(fd, content, 0, function()
			vim.uv.fs_close(fd, function()
				log("Saved to " .. path)
			end)
		end)
	end)
end

local banner = "\\n\\n\\033[0;33m--- Restored Layout ---\\033[0m\\n\\n"

---@param buf integer
---@param path string
local function send_restore(buf, path)
	if not vim.api.nvim_buf_is_valid(buf) then return end
	local chan = vim.bo[buf].channel
	if chan <= 0 then return end

	local esc_path = vim.fn.fnameescape(path)
	local cmd = string.format(
		" unset HISTFILE && cat %s && rm %s && printf \"%%b\" \"%s\" && exec %s\n",
		esc_path,
		esc_path,
		banner,
		vim.o.shell
	)

	vim.fn.chansend(chan, cmd)
end

function M.save()
	local now = vim.uv.now()
	if now - state.last_save_time < 1000 then return end
	state.last_save_time = now

	log("Save triggered")

	local entries = collect_terminals()
	vim.fn.mkdir(state.history_dir, "p")

	for _, entry in ipairs(entries) do
		local path = join_path(state.history_dir, ("seq_%d.log"):format(entry.idx))
		write_async(path, table.concat(entry.lines, "\n") .. "\n")
	end
end

function M.restore()
	state.restore_idx = state.restore_idx + 1
	local buf         = vim.api.nvim_get_current_buf()
	local path        = join_path(state.history_dir, ("seq_%d.log"):format(state.restore_idx))

	vim.uv.fs_stat(path, function(err)
		if err then
			log("restore file not found: " .. path)
			return
		end
		vim.schedule(function() send_restore(buf, path) end)
	end)
end

local aug = vim.api.nvim_create_augroup("PositionalTerminalHistory", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern  = "AutoSessionPreLoad",
	group    = aug,
	callback = function()
		state.history_dir = join_path(base_dir, project_hash())
		state.restore_idx = 0
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern  = "AutoSessionPreSave",
	group    = aug,
	callback = M.save,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group    = aug,
	callback = M.save,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group    = aug,
	callback = M.restore,
})

return M
