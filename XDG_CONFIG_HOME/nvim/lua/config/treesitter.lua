return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
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
			"python",
			"terraform",
			"toml",
			"tsv",
			"vim",
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
