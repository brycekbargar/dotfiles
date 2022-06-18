vim.g.loaded_python_provider = 0 -- disable python2
-- TODO: Figure out how to load providers from the conda env
-- Also TODO: Do these even do anything worthwhile in 202X?
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

require("plugins")
