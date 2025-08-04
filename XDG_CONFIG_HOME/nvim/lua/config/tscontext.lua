return function()
	local tsc = require("treesitter-context")
	tsc.setup({
		max_lines = 15,
		multiline_threshold = 5,
	})
end
