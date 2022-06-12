-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

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
	use({ "TC72/telescope-tele-tabby.nvim", as = "tele_tabby" })
	use({
		"nvim-telescope/telescope.nvim",
		after = { "catppuccin", "lsp-handlers", "tele_tabby" },
		requires = "nvim-lua/plenary.nvim",
		event = "VimEnter",
		config = require("config.telescope"),
	})
	use({
		"itchyny/lightline.vim",
		after = "catppuccin",
		config = require("config.lightline"),
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
