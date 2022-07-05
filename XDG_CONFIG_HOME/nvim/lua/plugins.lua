return require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	-- My plugins here
	-- Base
	use({ "tpope/vim-sensible", config = require("config.sensible") })
	use({ "tpope/vim-vinegar", config = require("config.vinegar") })
	use({ "tpope/vim-sleuth", event = "VimEnter", config = require("config.sleuth") })
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
		requires = "antoinemadec/FixCursorHold.nvim",
		event = "LspAttach",
		config = require("config.dinosaur"),
	})
	use({
		"gbrlsnchs/telescope-lsp-handlers.nvim",
		as = "lsp-handlers",
	})
	use({
		"lifepillar/vim-mucomplete",
		after = "lspconfig",
		config = require("config.mucomplete"),
	})

	-- Fanciness
	use({
		"stevearc/dressing.nvim",
		event = "VimEnter",
		config = require("config.dressing"),
	})
	use({
		"nvim-telescope/telescope.nvim",
		after = { "catppuccin", "lsp-handlers" },
		requires = "nvim-lua/plenary.nvim",
		event = "VimEnter",
		config = require("config.telescope"),
	})
	use({
		"itchyny/lightline.vim",
		after = "catppuccin",
		config = require("config.lightline"),
	})
end)
