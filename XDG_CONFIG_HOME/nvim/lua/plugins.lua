local packer = require("packer")
local util = require("packer.util")
return packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "nvim-lua/plenary.nvim" })
		use({ "kyazdani42/nvim-web-devicons" })

		-- Theme
		use({ "catppuccin/nvim", as = "catppuccin", config = require("config.catppuccin") })
		-- Editor
		use({
			"nvim-treesitter/nvim-treesitter",
			as = "treesitter",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.treesitter"),
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			after = "treesitter",
			config = require("config.blankline"),
		})
		use({
			"mhartington/formatter.nvim",
			cmd = { "Format", "FormatWrite" },
			config = require("config.neoformat"),
		})
		use({
			"fladson/vim-kitty",
			event = "BufEnter",
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
			"stevearc/dressing.nvim",
			event = "VimEnter",
			config = require("config.dressing"),
		})
		use({
			"rcarriga/nvim-notify",
			after = "catppuccin",
			event = "VimEnter",
			config = require("config.notify"),
		})
		use({
			"ibhagwan/fzf-lua",
			event = "VimEnter",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = require("config.fzf"),
		})
		use({
			"folke/trouble.nvim",
			after = "catppuccin",
			event = "VimEnter",
			requires = "kyazdani42/nvim-web-devicons",
			config = require("config.trouble"),
		})
		use({
			"itchyny/lightline.vim",
			after = "catppuccin",
			config = require("config.lightline"),
		})

		packer.sync()
	end,
	config = {
		package_root = util.join_paths(vim.fn.stdpath("state"), "site", "pack"),
		compile_path = util.join_paths(vim.fn.stdpath("state"), "plugin", "packer_compiled.lua"),
	},
})
