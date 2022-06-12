vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.g["mucomplete#enable_auto_at_startup"] = 1

return function() end
