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
		if client.server_capabilities.completionProvider then
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		end
		if client.server_capabilities.definitionProvider then
			vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
		end

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>l", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "<leader>le", function()
			require("telescope.builtin").diagnostics({ bufnr = bufnr })
		end, bufopts)
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<leader>lI", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<leader>lu", vim.lsp.buf.references, bufopts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
	end

	lsp.sumneko_lua.setup({
		on_attach = on_attach,
		cmd = conda_run.exe({ n = "lua-language-server" }).list(),
		root_dir = util.root_pattern(".luarc.json"),
		single_file_support = false,
	})

	lsp.jsonls.setup({
		on_attach = on_attach,
		cmd = conda_run.js({
			package = "vscode-langservers-extracted",
			n = "vscode-json-language-server",
		}).with_args({ "--stdio" }).list(),
		init_options = {
			provideFormatter = false,
		},
		root_dir = util.find_git_ancestor,
	})

	lsp.yamlls.setup({
		on_attach = on_attach,
		cmd = conda_run.js({
			n = "yaml-language-server",
		}).with_args({ "--stdio" }).list(),
		root_dir = util.find_git_ancestor,
		filetypes = { 'yaml', 'yaml.docker-compose', "yaml.ansible" },
	})

	lsp.ansiblels.setup({
		on_attach = on_attach,
		cmd = conda_run.js({
			package = "@ansible/ansible-language-server",
			n = "ansible-language-server",
		}).with_args({ "--stdio" }).list(),
		-- This is assuming:
		--   1. There's a local conda env with ansible you want to use
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

	local id = vim.api.nvim_create_augroup("DiagnosticFloat", {})
	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		pattern = "*",
		group = id,
		desc = "lua vim.diagnostic.open_float()",
		callback = vim.diagnostic.open_float,
	})
end
