local packer = require("packer")
local util = require("packer.util")
return packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "nvim-lua/plenary.nvim" })
		use({ "kyazdani42/nvim-web-devicons" })

		-- Theme
		use({
			"catppuccin/nvim",
			as = "catppuccin",
			config = require("config.catppuccin"),
		})
		-- Editor
		use({
			"nvim-treesitter/nvim-treesitter",
			as = "treesitter",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.treesitter"),
		})
		use({
			"nvim-treesitter/nvim-treesitter-context",
			after = "treesitter",
			config = require("config.tscontext"),
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			after = "treesitter",
			config = require("config.blankline"),
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			as = "lspconfig",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.lspconfig"),
		})
		use({
			"kosayoda/nvim-lightbulb",
			event = "LspAttach",
			config = require("config.dinosaur"),
		})

		-- Fanciness
		use({
			"nvim-lualine/lualine.nvim",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.lualine"),
			requires = "nvim-tree/nvim-web-devicons",
		})
		use({
			"rcarriga/nvim-notify",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.notify"),
		})
		use({
			"folke/trouble.nvim",
			after = "catppuccin",
			event = "VimEnter",
			requires = "kyazdani42/nvim-web-devicons",
			config = require("config.trouble"),
		})

		-- Language Packs
	end,
	config = {
		package_root = util.join_paths(
			vim.fn.stdpath("state"),
			"site",
			"pack"
		),
		compile_path = util.join_paths(
			vim.fn.stdpath("state"),
			"plugin",
			"packer_compiled.lua"
		),
	},
})
