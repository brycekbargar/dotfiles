local ts = require("nvim-treesitter")

ts.setup({
	install_dir = vim.fn.stdpath("state") .. "/site",
})
ts.install({
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
	"java",
	"javascript",
	"json",
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
	"vue",
	"yaml",
})

vim.cmd([[
	set foldmethod=expr
	set foldexpr='v:lua.vim.treesitter.foldexpr()'
	set nofoldenable
]])

require("treesitter-context").setup({
	max_lines = 15,
	multiline_threshold = 5,
})
