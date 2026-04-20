local jqfmt = {
	formatCommand = "jq",
	formatStdin = true,
}
local jqcheck = {
	lintSource = "efm/jq",
	lintCommand = "jq",
	lintStdin = true,
	lintOffset = 1,
	lintFormats = {
		"%m at line %l, column %c",
	},
}

local ruff = {
	{
		formatCommand = "ruff format --no-cache --quiet --stdin-filename '${INPUT}' -",
		formatStdin = true,
		root_markers = { "pyproject.toml" },
	},
	{
		formatCommand = "ruff check --quiet --fix-only --select I,COM812,COM819 --stdin-filename '${INPUT}' -",
		formatStdin = true,
		root_markers = { "pyproject.toml" },
	},
}

local stylua = {
	single_file_support = false,
	formatCommand = "stylua --color Never --search-parent-directories --stdin-filepath '${INPUT}' -- -",
	formatStdin = true,
	root_markers = { "stylua.toml" },
}

local shfmt = {
	formatCommand = "shfmt --simplify --filename '${INPUT}' -",
	formatStdin = true,
}
local shellcheck = {
	lintSource = "efm/shellcheck",
	lintCommand = "shellcheck --color=never --format=gcc -",
	lintIgnoreExitCode = true,
	lintStdin = true,
	lintFormats = {
		"-:%l:%c: %trror: %m",
		"-:%l:%c: %tarning: %m",
		"-:%l:%c: %tote: %m",
	},
}

local taplo = {
	formatCommand = "taplo fmt -",
	formatStdin = true,
}

return {
	cmd = { "efm-langserver" },
	filetypes = { "json", "lua", "python", "sh", "bash", "toml" },
	init_options = { documentFormatting = true },
	settings = {
		languages = {
			json = { jqfmt, jqcheck },
			lua = { stylua },
			python = ruff,
			sh = { shfmt, shellcheck },
			bash = { shfmt, shellcheck },
			toml = { taplo },
		},
		rootMarkers = { ".git/" },
	},
}
