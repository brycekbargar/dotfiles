vim.keymap.set("n", "<leader>tm", function()
	require("telescope.builtin").keymaps({ initial_mode = "insert" })
end, { noremap = true, silent = true })

return function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			initial_mode = "normal",
			mappings = {
				n = {
					["o"] = "select_horizontal",
					["v"] = "select_vertical",
					["t"] = "select_tab",
					["K"] = "preview_scrolling_up",
					["J"] = "preview_scrolling_down",
				},
			},
		},
	})

	telescope.load_extension("lsp_handlers")
end
