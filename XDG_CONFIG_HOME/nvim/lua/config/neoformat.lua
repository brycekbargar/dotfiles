vim.keymap.set("n", "<leader>f", ":Format<cr>", { noremap = true, silent = true })

return function()
	local format = require("formatter")
	local function filetype(formatter)
		return require("formatter.filetypes." .. formatter)
	end

	format.setup({
		filetype = {
			go = {
				function()
					local golines = filetype("go").golines()
					golines.args = golines.args or {}
					table.insert(golines.args, 1, "--max-len=80")
					table.insert(golines.args, 1, "--base-formatter=gofumpt")
					return golines
				end,
			},

			json = { filetype("json").fixjson },
			jsonc = { filetype("json").fixjson },
			lua = { filetype("lua").stylua },

			ps1 = {
				function()
					local InvokeFormatter = {
						exe = "PowerShellEditorServices",
						args = "/powershell_sa/Invoke-Formatter",
					}
					InvokeFormatter.stdin = true
					return InvokeFormatter
				end,
			},

			python = {
				function()
					local isort = filetype("python").isort()
					isort.args = isort.args or {}
					table.insert(isort.args, 1, "--profile")
					table.insert(isort.args, 1, "black")
					return isort
				end,
				filetype("python").black,
			},

			sh = {
				function()
					local shfmt = filetype("sh").shfmt()
					shfmt.args = shfmt.args or {}
					table.insert(shfmt.args, 1, "--simplify")
					return shfmt
				end,
			},

			terraform = { filetype("terraform").terraformfmt },
			toml = { filetype("toml").taplo },
			yaml = { filetype("yaml").yamlfmt },
			["yaml.ansible"] = { filetype("yaml").yamlfmt },
		},
	})
end
