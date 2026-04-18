vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { "stylua.toml" },
	settings = { Lua = { telemetry = { enable = true } } },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("efm", {
	filetypes = { "lua" },
	settings = {
		languages = {
			lua = {
				single_file_support = false,
				formatCommand = "stylua --color Never --search-parent-directories --stdin-filepath '${INPUT}' -- -",
				formatStdin = true,
				root_markers = { "stylua.toml" },
			},
		},
	},
})
