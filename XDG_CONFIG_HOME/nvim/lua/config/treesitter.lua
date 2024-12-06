return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"astro",
			"bash",
			"css",
			"csv",
			"dockerfile",
			"gitattributes",
			"gitignore",
			"go",
			"gosum",
			"gomod",
			"hcl",
			"html",
			"javascript",
			"json",
			"jsonc",
			"json5",
			"lua",
			"make",
			"markdown",
			"python",
			"terraform",
			"toml",
			"tsv",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
		incremental_selection = {
			enable = false,
		},
	})

	vim.cmd([[
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
	set nofoldenable
	]])
end
