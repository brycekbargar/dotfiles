return function()
	local trouble = require("trouble")
	trouble.setup({})

	vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>te", "<cmd>Trouble document_diagnostics<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tE", "<cmd>Trouble workspace_diagnostics<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tr", "<cmd>Trouble lsp_references<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>td", "<cmd>Trouble lsp_definitions<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ti", "<cmd>Trouble lsp_implementations<cr>", { noremap = true, silent = true })
end
