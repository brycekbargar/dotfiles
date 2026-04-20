vim.lsp.config("efm", {
	filetypes = { "json" },
	settings = {
		languages = {
			json = {
				{
					formatCommand = "jq",
					formatStdin = true
				},
				{
					prefix = "jq",
					lintSource = "efm/jq",
					lintCommand = "jq",
					lintStdin = true,
					lintOffset = 1,
					lintFormats = {
						'%m at line %l, column %c',
					},
				},
			},
		},
	},
})
