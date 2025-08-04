return function()
	local catppuccin = require("catppuccin")

	catppuccin.setup({
		flavour = "frappe",
		dim_inactive = { enabled = true },
		default_integrations = false,
		integrations = {
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			notify = true,
			treesitter_context = true,
			treesitter = true,
			lsp_trouble = true,
		},
	})

	vim.cmd([[colorscheme catppuccin]])
end
