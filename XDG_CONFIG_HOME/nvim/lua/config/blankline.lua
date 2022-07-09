return function()
	vim.opt.listchars:append("tab:  →")
	vim.opt.listchars:append("multispace:·")
	vim.opt.listchars:append("trail:✗")
	vim.opt.listchars:append("nbsp:␣")

	require("indent_blankline").setup({
		space_char_blankline = " ",
		char_highlight_list = {
			"IndentBlanklineIndent1",
			"IndentBlanklineIndent2",
			"IndentBlanklineIndent3",
			"IndentBlanklineIndent4",
			"IndentBlanklineIndent5",
			"IndentBlanklineIndent6",
		},
		filetype_exclude = { "netrw", "help" },
		show_trailing_blankline_indent = false,
		use_treesitter = true,
		show_current_context = true,
		show_current_context_start = true,
	})
end
