vim.opt.signcolumn = "number"
vim.diagnostic.config({
	severity_sort = true,
})
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

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("dotfiles.lsp", {}),
	callback = function(ev)
		if ev.data == nil then return end

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end

		vim.notify(
			client.name .. " active",
			vim.log.levels.INFO,
			{ title = "LspInfo" }
		)

		local bufopts = { noremap = true, silent = true, buffer = ev.buf }
		vim.keymap.set("n", "<leader>f", function()
			for _, c in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
				if c.name == "jdtls" then
					-- these lsps support formatting
					-- but there's no accompyaning for efm to call
					vim.lsp.buf.format({ name = c.name, timeout_ms = 2000 })
					return
				end
			end
			vim.lsp.buf.format({ name = "efm", timeout_ms = 2000 })
		end, bufopts)
	end,
})

return function() vim.lsp.enable({ "efm", "lua", "python", "toml" }) end
