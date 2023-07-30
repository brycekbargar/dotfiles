return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
			"dockerfile",
			"go",
			"gosum",
			"gomod",
			"html",
			"hcl",
			"json",
			"jsonc",
			"json5",
			"lua",
			"make",
			"python",
			"terraform",
			"toml",
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
