vim.opt.signcolumn = "number"
vim.diagnostic.config({
	severity_sort = true,
})

return function()
	local lsp = require("lspconfig")
	-- mucomplete stopped mapping this because nvim overwrites them...
	vim.keymap.set("i", "<Tab>", "<plug>(MUcompleteFwd)")
	vim.keymap.set("i", "<S-Tab>", "<plug>(MUcompleteBwd)")
	vim.keymap.set(
		"n",
		"gre",
		function()
			vim.diagnostic.config({
				virtual_lines = not vim.diagnostic.config().virtual_lines,
			})
		end
	)

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

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set(
			"n",
			"<leader>f",
			function() vim.lsp.buf.format({ name = "efm", timeout_ms = 2000 }) end,
			bufopts
		)
	end

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
			"json",
			"lua",
			"ps1",
			"python",
			"sh",
			"toml",
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
	lsp.ruff.setup({
		on_attach = on_attach,
		single_file_support = false,
	})

	lsp.taplo.setup({ on_attach = on_attach })

	lsp.yamlls.setup({ on_attach = on_attach })
end
