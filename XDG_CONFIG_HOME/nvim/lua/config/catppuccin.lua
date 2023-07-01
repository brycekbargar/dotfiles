return function()
	local catppuccin = require("catppuccin")

	catppuccin.setup({
		integrations = {
			lsp_trouble = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
			notify = true,
		},
	})

	vim.g.catppuccin_flavour = "frappe"
	vim.cmd([[colorscheme catppuccin]])
end
