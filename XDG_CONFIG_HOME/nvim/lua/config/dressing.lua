return function()
	local dressing = require("dressing")
	dressing.setup({
		select = {
			backend = { "builtin" },
		},
	})
end
