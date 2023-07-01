return function()
	vim.cmd.MUcompleteNotify(3)
	vim.opt.showmode = false

	local lualine = require("lualine")
	lualine.setup({
		options = {
			theme = "catppuccin",
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
end
