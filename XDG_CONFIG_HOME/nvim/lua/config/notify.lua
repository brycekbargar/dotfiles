return function()
	local notify = require("notify")
	notify.setup({})
	vim.notify = notify
end
