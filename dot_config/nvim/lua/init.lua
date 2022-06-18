local g = vim.g

g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0 -- disable python2
-- TODO: Figure out how to load the node provider from the conda env
g.loaded_node_provider = 0

local CONDA_EXE = vim.env.CONDA_EXE
if CONDA_EXE then
	local resolve = vim.fn.resolve
	local fnamemodify = vim.fn.fnamemodify

	-- TODO: Resolve this path in a less cludgy way
	local conda_nvim_bin = resolve(fnamemodify(CONDA_EXE, ":p:h") .. "/..") .. "/envs/nvim/bin/"
	g.python3_host_prog = conda_nvim_bin .. "python3"
else
	g.loaded_python3_provider = 0
end

require("plugins")
