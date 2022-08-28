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

	vim.keymap.set("n", "<leader>te", function()
		fzf.diagnostics_document()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tE", function()
		fzf.diagnostics_workspace()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>td", function()
		require("fzf-lua").lsp_declarations()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tD", function()
		require("fzf-lua").lsp_definitions()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ti", function()
		require("fzf-lua").lsp_implementations()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tI", function()
		require("fzf-lua").lsp_typedefs()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tr", function()
		require("fzf-lua").lsp_references()
	end, { noremap = true, silent = true })
end
