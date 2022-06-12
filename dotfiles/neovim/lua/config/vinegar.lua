vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_usetab = 1
vim.g.netrw_wiw = 30

local opts = { noremap = true, silent = true }
-- go to the first tab which is usually a file tree
vim.keymap.set("n", "<leader>k", "1gt", opts)
-- shrink/grow the preview pane
vim.keymap.set("n", "<leader>k<tab>", function()
	local function pane_left()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-w>h", true, true, true), "m", false)
	end
	-- If shrunk from the preview pane it show another tree
	pane_left()
	vim.cmd("call netrw#Shrink()")
	-- Shrinking it move focus to the preview pane
	pane_left()
end, opts)

return function() end
