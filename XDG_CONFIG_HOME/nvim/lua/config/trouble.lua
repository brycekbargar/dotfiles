return function()
	local trouble = require("trouble")
	trouble.setup({})

	vim.keymap.set(
		"n",
		"<leader>tt",
		"<cmd>TroubleToggle<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>te",
		"<cmd>Trouble document_diagnostics<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>tE",
		"<cmd>Trouble workspace_diagnostics<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>tr",
		"<cmd>Trouble lsp_references<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>td",
		"<cmd>Trouble lsp_definitions<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>ti",
		"<cmd>Trouble lsp_implementations<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>tco",
		":copen<cr>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>tlo",
		":lopen<cr>",
		{ noremap = true, silent = true }
	)

	local function native_trouble(win)
		return function()
			vim.defer_fn(function()
				if win == "quickfix" then
					vim.cmd("cclose")
				else
					vim.cmd("lclose")
				end
				trouble.open(win)
			end, 0)
		end
	end
	local function native_trouble_detect()
		local nt = native_trouble("quickfix")
		if vim.fn.getloclist(0, { filewinid = 1 }).filewinid > 0 then
			nt = native_trouble("loclist")
		end
		nt()
	end
	local group = vim.api.nvim_create_augroup("NvimTroubleQuickfix", {})
	-- For some reason this has to be duplicated here even though it is in the init.vim
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		pattern = "l*",
		group = group,
		callback = native_trouble("loclist"),
	})
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		pattern = "[^l]*",
		group = group,
		callback = native_trouble("quickfix"),
	})
	vim.api.nvim_create_autocmd("BufWinEnter", {
		pattern = "quickfix",
		group = group,
		callback = native_trouble_detect,
	})
end
