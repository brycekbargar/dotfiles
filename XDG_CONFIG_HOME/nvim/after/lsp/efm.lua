vim.lsp.config("efm", {
	init_options = { documentFormatting = true },
	settings = { rootMarkers = { ".git/" } },
})
vim.lsp.enable("efm")
