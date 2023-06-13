vim.keymap.set("n", "<leader>f", ":Format<cr>", { noremap = true, silent = true })

return function()
	local format = require("formatter")
	local function filetype(formatter)
		return require("formatter.filetypes." .. formatter)
	end

	format.setup({
		filetype = {
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
					local isort = filetype("python").isort
					table.insert(isort.args, 1, "--profile")
					table.insert(isort.args, 1, "black")
					return isort
				end,
				filetype("python").black,
			},

			sh = {
				function()
					local shfmt = filetype("bash").shfmt
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
