return require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" })

	-- Theme
	use({ 
		"catppuccin/nvim", as = "catppuccin", config = require("config.catppuccin") })

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
