local M = {}

local function concat_args(t1, t2)
	if t1 == nil then
		t1 = {}
	end
	if t2 == nil then
		return t1
	end
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

-- TODO: Refactor this to be not conda specific anymore
local conda_run = function(executable, docker)
	local m = {}
	if docker then
		m.cmd = "docker"
		m.args = concat_args({ "run", "--rm", "-i" }, executable)
	else
		m.cmd = "umamba"
		m.args = concat_args({ "run", "-p", vim.env.CONDA_SYSTEM .. "/nvim" }, executable)
	end

	m.exe = m.cmd
	m.path = m.cmd
	m.arguments = m.args

	function m.with_args(args)
		m.args = concat_args(m.args, args)
		m.arguments = m.args

		return m
	end

	function m.list()
		return concat_args({ m.cmd }, m.args)
	end

	function m.string()
		return table.concat(m.list(), " ")
	end

	return m
end

function M.exe(t)
	return conda_run({ t.n })
end

function M.js(t)
	if t.package then
		return conda_run({ "npm", "exec", "--yes", "--package=" .. t.package .. "@latest", "--", t.n })
	end
	return conda_run({ "npm", "exec", "--yes", "--", t.n .. "@latest" })
end

function M.python(t)
	if t.package then
		return conda_run({ "pipx", "run", "--spec=" .. t.package, "--", t.n })
	end
	return conda_run({ "pipx", "run", "--", t.n })
end

function M.pwsh(t)
	return conda_run({ "brycekbargar.com/pwsh", t.n }, true)
end

return M
