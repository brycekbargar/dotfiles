return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
			"dockerfile",
			"go",
			"gosum",
			"gomod",
			"hcl",
			"jsonc",
			"lua",
			"python",
			"rst",
			"terraform",
			"toml",
			"yaml",
		},
		incremental_selection = {
			enable = false,
		},
	})
end
