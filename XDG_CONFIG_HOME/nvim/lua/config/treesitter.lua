return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
			"css",
			"csv",
			"dockerfile",
			"git_config",
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
			"markdown_inline",
			"nginx",
			"python",
			"toml",
			"tsv",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
		incremental_selection = {
			enable = false,
		},
		sync_install = false,
		auto_install = false,
		ignore_install = {},
	})

	vim.cmd([[
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
	set nofoldenable
	]])
end
