vim.opt.timeoutlen = 400
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.hidden = true

local opts = { noremap = true, silent = true }
vim.keymap.set("", "<Space>", ":", { noremap = true })
vim.keymap.set("", "'", "<Nop>", opts)
vim.g.mapleader = "'"
vim.g.maplocalleader = "'"
vim.keymap.set("n", "<Left>", ":vertical resize -4<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +4<CR>", opts)
vim.keymap.set("n", "<Up>", ":resize -4<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +4<CR>", opts)

return function() end
