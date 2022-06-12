return function()
	local ts = require("nvim-treesitter.configs")
	ts.setup({
		ensure_installed = {
			"bash",
			"dockerfile",
			"go",
			"gomod",
			"hcl",
			"jsonc",
			"lua",
			"python",
			"rst",
			"toml",
			"yaml",
		},
		incremental_selection = {
			enable = false,
		},
	})
end
