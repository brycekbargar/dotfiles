local shfmt = {
	formatCommand = "shfmt -filename '${INPUT}' -",
	formatStdin = true,
}

local shellcheck = {
	prefix = "shellcheck",
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

vim.lsp.config("efm", {
	filetypes = { "bash", "sh" },
	settings = {
		languages = {
			bash = { shfmt, shellcheck },
			sh = { shfmt, shellcheck },
		},
	},
})
