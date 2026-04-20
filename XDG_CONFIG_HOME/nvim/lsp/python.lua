return {
	filetypes = { "python" },
	languages = {
		python = {
			{ cmd = { "ruff", "server" } },
			{ cmd = { "ty", "server" } },
		},
	},
	root_markers = { "pyproject.toml" },
	single_file_support = false,
}
