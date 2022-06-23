vim.keymap.set("n", "<leader>f", ":Format<cr>", { noremap = true, silent = true })

return function()
	local format = require("formatter")
	local util = require("formatter.util")
	local conda_run = require("conda-run")
	local function prettier(parser)
		return {
			function()
				local p = conda_run.js({ n = "prettier" }).with_args({
					"--stdin-filepath",
					util.escape_path(util.get_current_buffer_file_path()),
					"--parser",
					parser,
				})
				p.stdin = true
				return p
			end,
		}
	end
	format.setup({
		filetype = {
			lua = {
				function()
					local stylua = conda_run.exe({ n = "stylua" }).with_args({
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					})
					stylua.stdin = true
					return stylua
				end,
			},
			json = prettier("json"),
			jsonc = prettier("jsonc"),
			yaml = prettier("yaml"),
			toml = {
				function()
					local stylua = conda_run.exe({ n = "taplo" }).with_args({
						"fmt",
						"-",
					})
					stylua.stdin = true
					return stylua
				end,
			},
			["yaml.ansible"] = prettier("yaml"),
			markdown = prettier("markdown"),
		},
	})
end
