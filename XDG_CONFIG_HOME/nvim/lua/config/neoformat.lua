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
			["yaml.ansible"] = prettier("yaml"),
			markdown = prettier("markdown"),

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

			python = {
				function()
					local isort = conda_run.exe({ n = "isort" }).with_args({
						"--profile",
						"black",
						"--quiet",
						"-",
					})
					isort.stdin = true
					return isort
				end,
				function()
					local black = conda_run.exe({ n = "black" }).with_args({
						"--stdin-filename",
						util.escape_path(util.get_current_buffer_file_path()),
						"--quiet",
						"-",
					})
					black.stdin = true
					return black
				end,
			},

			sh = {
				function()
					local shiftwidth = vim.opt.shiftwidth:get()
					local expandtab = vim.opt.expandtab:get()

					if not expandtab then
						shiftwidth = 0
					end

					local shfmt = conda_run.exe({ n = "shfmt" }).with_args({
						"-i",
						shiftwidth,
						"--simplify",
					})
					shfmt.stdin = true
					return shfmt
				end,
			},

			terraform = {
				function()
					local terraform = conda_run.exe({ n = "terraform" }).with_args({
						"fmt",
						"-",
					})
					terraform.stdin = true
					return terraform
				end,
			},

		},
	})
end
