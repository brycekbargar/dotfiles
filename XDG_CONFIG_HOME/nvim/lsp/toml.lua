vim.lsp.config("taplo", {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { ".git" },
})
vim.lsp.enable("taplo")

vim.lsp.config("efm", {
	filetypes = { "toml" },
	settings = {
		languages = {
			lua = {
				formatCommand = "taplo fmt -",
				formatStdin = true,
			},
		},
	},
})
