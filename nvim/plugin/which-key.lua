local wk = require("which-key")

wk.setup()
wk.add({
	{ "gc", group = "Comment",       mode = { "n", "v" } },
	{ "gb", group = "Comment Block", mode = { "n", "v" } },
})
