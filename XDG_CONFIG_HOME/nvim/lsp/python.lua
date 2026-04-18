vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml" },
	single_file_support = false,
})
vim.lsp.enable("ruff")

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"requirements.txt",
		".git",
	},
})
vim.lsp.enable("ty")

vim.lsp.config("efm", {
	filetypes = { "python" },
	settings = {
		languages = {
			python = {
				{
					formatCommand = "ruff format --no-cache --quiet --stdin-filename '${INPUT}' -",
					formatStdin = true,
					root_markers = { "pyproject.toml" },
				},
				{
					formatCommand = "ruff check --quiet --fix-only --select I,COM812,COM819 --stdin-filename '${INPUT}' -",
					formatStdin = true,
					root_markers = { "pyproject.toml" },
				},
			},
		},
	},
})
