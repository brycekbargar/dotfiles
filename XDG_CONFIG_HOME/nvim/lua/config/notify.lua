return function()
	local notify = require("notify")
	notify.setup({
		max_width = 100,
		max_height = 50,
		timeout = 500,
		render = "minimal",
		stages = "fade",
		on_open = function(win)
			vim.api.nvim_set_option_value("wrap", true, { win = win })
			vim.api.nvim_win_set_config(win, { focusable = false })
		end,
	})
	vim.notify = notify
end
