return function()
	local notify = require("notify")
	notify.setup({
		max_width = 100,
		max_height = 50,
		timeout = 1000,
		render = "minimal",
		stages = "fade",
		on_open = function(win) vim.api.nvim_win_set_option(win, "wrap", true) end,
	})
	vim.notify = notify
end
