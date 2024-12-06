vim.opt.signcolumn = "number"
vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
})

return function()
	local lsp = require("lspconfig")
	local lsputil = require("lspconfig.util")
	local version = (function()
		local v = vim.version()
		return v.major .. "." .. v.minor .. "." .. v.patch
	end)()

	local on_attach = function(client, bufnr)
		vim.notify(
			client.name .. " active",
			vim.log.levels.INFO,
			{ title = "LspInfo" }
		)

		if client.server_capabilities.completionProvider then
			vim.api.nvim_buf_set_option(
				bufnr,
				"omnifunc",
				"v:lua.vim.lsp.omnifunc"
			)
		end
		if client.server_capabilities.definitionProvider then
			vim.api.nvim_buf_set_option(
				bufnr,
				"tagfunc",
				"v:lua.vim.lsp.tagfunc"
			)
		end

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>t", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "<leader>T", vim.diagnostic.open_float, bufopts)
		vim.keymap.set("n", "<leader>tR", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<leader>ta", vim.lsp.buf.code_action, bufopts)

		vim.keymap.set(
			"n",
			"<leader>f",
			function() vim.lsp.buf.format({ name = "efm", timeout_ms = 2000 }) end,
			bufopts
		)
	end

	lsp.ansiblels.setup({
		on_attach = on_attach,
		single_file_support = false,
	})

	lsp.bashls.setup({ on_attach = on_attach })

	lsp.dockerls.setup({ on_attach = on_attach })

	lsp.efm.setup({
		on_attach = on_attach,
		cmd = {
			"efm-langserver",
			"-c",
			vim.env.XDG_CONFIG_HOME .. "/nvim/lua/config/efm.yaml",
		},
		init_options = { documentFormatting = true },
		filetypes = {
			"go",
			"html",
			"javascript",
			"json",
			"lua",
			"ps1",
			"python",
			"sh",
			"yaml",
		},
	})

	lsp.gopls.setup({
		on_attach = on_attach,
		single_file_support = false,
	})
	lsp.golangci_lint_ls.setup({ on_attach = on_attach })

	lsp.html.setup({
		init_options = {
			configurationSection = { "html" },
			provideFormatter = false,
		},
	})

	lsp.jsonls.setup({
		on_attach = on_attach,
		init_options = {
			provideFormatter = false,
		},
	})

	lsp.lua_ls.setup({
		on_attach = on_attach,
		single_file_support = false,
		settings = { Lua = { telemetry = { enable = true } } },
	})

	lsp.powershell_es.setup({
		on_attach = on_attach,
		cmd = {
			"PowerShellEditorServices",
			"/powershell_es/Start-EditorServices.ps1",
			"-BundledModulesPath",
			"/powershell_es",
			"-SessionDetailsPath",
			"/powershell_es/session.json",
			"-LogPath",
			"/powershell_es/session.log",
			"-HostName",
			"nvim",
			"-HostProfileId",
			"0",
			"-HostVersion",
			version,
			"-Stdio",
		},
	})

	lsp.pyright.setup({
		on_attach = on_attach,
		commands = {},
	})

<<<<<<< HEAD
	lsp.quick_lint_js.setup({
		cmd = { "npx", "--no", "quick-lint-js", "--", "--lsp-server" },
		on_attach = on_attach,
		single_file_support = false,
	})

	lsp.ruff.setup({
		on_attach = on_attach,
		single_file_support = false,
	})

	lsp.tailwindcss.setup({
		on_attach = on_attach,
		filetypes = { "html" },
		root_dir = lsputil.root_pattern("tailwind.config.js"),
	})

=======
>>>>>>> 07c0684 (Remove unused js config)
	lsp.taplo.setup({ on_attach = on_attach })

	lsp.yamlls.setup({ on_attach = on_attach })
end
