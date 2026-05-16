vim.filetype.add({
	pattern = {
		["roles/.+%.ya?ml"] = "yaml.ansible",
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
})
