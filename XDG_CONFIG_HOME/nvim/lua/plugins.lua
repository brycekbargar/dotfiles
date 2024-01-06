require("lazy").setup({
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	-- Theme
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = require("config.catppuccin"),
	},

	-- Editor
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		config = require("config.treesitter"),
	},
	"nvim-treesitter/nvim-treesitter-context",
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		config = require("config.blankline"),
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		config = require("config.lspconfig"),
	},
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		config = require("config.dinosaur"),
	},

	-- Fanciness
	{
		"nvim-lualine/lualine.nvim",
		config = require("config.lualine"),
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = require("config.dressing"),
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = require("config.notify"),
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		config = require("config.trouble"),
	},

	-- Language Packs
	{ "pearofducks/ansible-vim" },
}, {
	defaults = { lazy = true },
	root = vim.fn.stdpath("state") .. "/site/pack",
	lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
})
