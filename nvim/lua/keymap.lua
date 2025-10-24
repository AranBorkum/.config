local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		if opts.desc then
			opts.desc = "keymaps.lua: " .. opts.desc
		end
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.exrc = true
-- vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

map("n", "<C-d>", "<C-d>zz", { desc = "" })
map("n", "<C-u>", "<C-u>zz", { desc = "" })
map("n", "n", "nzz", { desc = "" })
map("n", "N", "Nzz", { desc = "" })
map("n", "<leader>BD", ":%bd!<cr>|:Oil<cr>", { desc = "" })
map("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
