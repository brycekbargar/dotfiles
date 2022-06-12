vim.keymap.set("n", "<leader>m", function()
	require("telescope.builtin").keymaps({ initial_mode = "insert" })
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", function()
	require("telescope").extensions.tele_tabby.list()
end, { silent = true, noremap = true })

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
	telescope.load_extension("tele_tabby")
end
