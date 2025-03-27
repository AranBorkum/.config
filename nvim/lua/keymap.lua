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

map("n", "<C-d>", "<C-d>zz", { desc = ""})
map("n", "<C-u>", "<C-u>zz", { desc = ""})
