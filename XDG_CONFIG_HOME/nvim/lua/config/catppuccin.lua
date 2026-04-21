require("catppuccin").setup({
	flavour = "frappe",
	dim_inactive = { enabled = true },
	default_integrations = false,
	integrations = {
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
		notify = true,
		treesitter_context = true,
		treesitter = true,
		lsp_trouble = true,
	},
})

vim.cmd([[colorscheme catppuccin-nvim]])
