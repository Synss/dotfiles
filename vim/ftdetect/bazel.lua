vim.filetype.add({
	extension = {
		star = "bzl",
		bazel = "bzl",
	},
	filename = {
		["BUILD"] = "bzl",
		["WORKSPACE"] = "bzl",
	},
})
