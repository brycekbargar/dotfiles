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

local conda_run = function(executable)
	local m = {}
	m.cmd = "umamba"
	m.exe = m.cmd
	m.path = m.cmd
	m.args = concat_args({ "run", "-p", vim.env.CONDA_SYSTEM .. "/nvim" }, executable)
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

return M
