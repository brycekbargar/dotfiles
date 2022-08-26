return function()
	local catppuccin = require("catppuccin")

	catppuccin.setup({
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
			},
			telescope = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
			-- lightline = true,
			-- markdown = true,
			-- disable defaults
			cmp = false,
			gitsigns = false,
			nvimtree = {
				enabled = false,
			},
			dashboard = false,
			bufferline = false,
			notify = false,
			telekasten = false,
			symbols_outline = false,
			vimwiki = false,
			beacon = false,
		},
	})

	vim.g.catppuccin_flavour = "frappe"
	vim.cmd([[colorscheme catppuccin]])
end
