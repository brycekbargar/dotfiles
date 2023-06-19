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

	vim.keymap.set("n", "<leader>z", function()
		fzf.resume()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ze", function()
		fzf.files()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>zts", function()
		fzf.tagstack()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>zkm", function()
		fzf.keymaps()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>zls", function()
		fzf.buffers()
	end, { noremap = true, silent = true })
end
