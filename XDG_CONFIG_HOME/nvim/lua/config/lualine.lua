vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("dotfiles.lualine", {}),
	callback = function() vim.cmd.MUcompleteNotify(3) end,
})
vim.opt.showmode = false

require("lualine").setup({
	options = {
		theme = "catppuccin-nvim",
		component_separators = { left = nil, right = nil },
		disabled_filetypes = {
			statusline = { "help" },
		},
	},
	sections = {
		lualine_a = { "mode", "g:mucomplete_current_method" },
		lualine_b = { "FugitiveHead" },
		lualine_c = {
			{ "filetype", icon_only = true },
			{ "filename" },
		},
		lualine_x = {},
		lualine_y = { "location" },
		lualine_z = { "SleuthIndicator", "fileformat" },
	},
	inactive_sections = {
		lualine_c = {
			{ "filename", file_status = false, path = 1 },
		},
		lualine_x = {},
	},
	extensions = {
		"fugitive",
		"trouble",
		{
			sections = {
				lualine_a = { "mode" },
				lualine_c = { "b:netrw_curdir" },
			},
			filetypes = { "netrw" },
		},
	},
})
