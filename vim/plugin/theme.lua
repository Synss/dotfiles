local config_dir = vim.fn.stdpath("config")
local pref_path = os.getenv("HOME") .. "/.theme-preference"

local function read_theme_config(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	local ok, config = pcall(vim.json.decode, content)
	return ok and config or nil
end

local function read_bg_preference(path)
	local file = io.open(path, "r")
	if not file then
		return "dark"
	end
	local bg = file:read("*l")
	file:close()
	return (bg == "light") and "light" or "dark"
end

local function colorscheme_for(config, bg)
	if not config then
		return nil
	end
	return config.colorscheme or config[bg]
end

local function apply_theme(bg, colorscheme)
	if colorscheme then
		vim.cmd("colorscheme " .. colorscheme)
	end
	vim.o.background = bg
end

-- I/O: write bg to per-instance file so :terminal shells can read it
local function write_instance_theme(bg)
	local socket = vim.v.servername
	if socket ~= "" then
		os.execute("echo " .. bg .. " > " .. socket .. ".theme")
	end
end

local config = read_theme_config(config_dir .. "/theme-config.json")
local bg = read_bg_preference(pref_path)

apply_theme(bg, colorscheme_for(config, bg))
write_instance_theme(bg)

local function switch(bg_val)
	apply_theme(bg_val, colorscheme_for(config, bg_val))
	write_instance_theme(bg_val)
	os.execute("echo " .. bg_val .. " > " .. pref_path)
end

vim.api.nvim_create_user_command("Dark", function()
	switch("dark")
end, {})
vim.api.nvim_create_user_command("Light", function()
	switch("light")
end, {})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		local socket = vim.v.servername
		if socket ~= "" then
			os.remove(socket .. ".theme")
		end
	end,
})
