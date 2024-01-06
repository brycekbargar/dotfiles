return function()
	local lightbulb = require("nvim-lightbulb")
	lightbulb.setup({
		sign = { enabled = false },
		virtual_text = { enabled = true, text = "🦖" },
		autocmd = { enabled = true },
	})

	vim.g.cursorhold_updatetime = 50
end
