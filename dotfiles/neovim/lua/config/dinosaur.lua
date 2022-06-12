return function()
	local lightbulb = require("nvim-lightbulb")
	lightbulb.setup({
		sign = { enabled = true },
		autocmd = { enabled = true },
	})

	vim.g.cursorhold_updatetime = 50
	vim.fn.sign_define("LightBulbSign", { text = "🦖" })
end
