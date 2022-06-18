vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.keymap.set("n", "<leader>lm", ":MUcompleteAutoToggle<CR>", { silent = true, noremap = true })

return function() end
