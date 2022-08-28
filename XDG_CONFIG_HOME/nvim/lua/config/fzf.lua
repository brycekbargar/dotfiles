return function()
	local fzf = require("fzf-lua")
	fzf.setup({
		winopts = {
			fullscreen = true,
			preview = {
				layout = "horizontal",
			},
		},
		grep = {
			rg_opts = "--column --color=always --max-columns=512",
			path_shorten = true,
		},
	})

	vim.api.nvim_create_user_command("Rg", function(opts)
		fzf.grep({ search = opts.args })
	end, { nargs = 1, desc = "rg-fzf" })
	vim.api.nvim_create_user_command("Fd", function()
		-- TODO: Figure out how to pass an initial query
		fzf.files()
	end, { desc = "fd-fzf" })

	vim.keymap.set("n", "<leader>km", function()
		fzf.keymaps()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ls", function()
		fzf.buffers()
	end, { noremap = true, silent = true })
end
