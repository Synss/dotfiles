vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local session_dir = vim.fn.stdpath("data") .. "/sessions"
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

local function get_session_path()
	local cwd = vim.fn.getcwd():gsub("[/\\]", "%%"):gsub(":", "++")
	return session_dir .. "/" .. cwd .. ".vim"
end

local session_to_use = get_session_path()

vim.api.nvim_create_autocmd("VimEnter", {
	nested = true,
	callback = function()
		if vim.fn.argc() == 0 and vim.fn.filereadable(session_to_use) == 1 then
			vim.cmd("source " .. vim.fn.fnameescape(session_to_use))
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("mksession! " .. vim.fn.fnameescape(session_to_use))
		end
	end,
})
