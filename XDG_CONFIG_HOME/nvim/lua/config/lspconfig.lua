vim.opt.signcolumn = "number"
vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
})

return function()
	local lsp = require("lspconfig")
	local util = require("lspconfig.util")
	local conda_run = require("conda-run")

	local on_attach = function(client, bufnr)
		vim.notify("LSP Active", "INFO", { title = "LSP | " .. client.name })

		if client.server_capabilities.completionProvider then
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		end
		if client.server_capabilities.definitionProvider then
			vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
		end

		local fzf = require("fzf-lua")
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>t", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "<leader>tR", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<leader>ta", vim.lsp.buf.code_action, bufopts)
	end

	lsp.sumneko_lua.setup({
		on_attach = on_attach,
		cmd = conda_run.exe({ n = "lua-language-server" }).list(),
		root_dir = util.root_pattern(".luarc.json"),
		single_file_support = false,
	})

	lsp.jsonls.setup({
		on_attach = on_attach,
		cmd = conda_run
			.js({
				package = "vscode-langservers-extracted",
				n = "vscode-json-language-server",
			})
			.with_args({ "--stdio" })
			.list(),
		init_options = {
			provideFormatter = false,
		},
		root_dir = util.find_git_ancestor,
	})

	lsp.yamlls.setup({
		on_attach = on_attach,
		cmd = conda_run
			.js({
				n = "yaml-language-server",
			})
			.with_args({ "--stdio" })
			.list(),
		root_dir = util.find_git_ancestor,
		filetypes = { "yaml", "yaml.docker-compose", "yaml.ansible" },
	})

	lsp.taplo.setup({
		on_attach = on_attach,
		cmd = conda_run
			.exe({
				n = "taplo",
			})
			.with_args({ "lsp", "stdio" })
			.list(),
		root_dir = util.find_git_ancestor,
	})

	lsp.ansiblels.setup({
		on_attach = on_attach,
		cmd = conda_run
			.js({
				package = "@ansible/ansible-language-server",
				n = "ansible-language-server",
			})
			.with_args({ "--stdio" })
			.list(),
		-- This is assuming:
		--   1. There's a local conda env with ansible
		--   2. There's a shim script to run ansible using that env
		--   3. The ansiblels continues to assume ansible-lint and ansible are in the same venv
		root_dir = util.root_pattern(".conda-ansible"),
		config = {
			ansible = {
				path = ".conda-ansible",
			},
		},
		single_file_support = false,
	})

	lsp.pyright.setup({
		on_attach = on_attach,
		cmd = conda_run
			.js({
				package = "pyright",
				n = "pyright-langserver",
			})
			.with_args({ "--stdio" })
			.list(),
	})

	local id = vim.api.nvim_create_augroup("DiagnosticFloat", {})
	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		pattern = "*",
		group = id,
		desc = "lua vim.diagnostic.open_float()",
		callback = vim.diagnostic.open_float,
	})
end
