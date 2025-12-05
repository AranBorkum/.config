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
vim.opt.termguicolors = true
-- vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

map("n", "<C-d>", "<C-d>zz", { desc = "Center current line when paging down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Center current line when paging up" })
map("n", "n", "nzz", { desc = "Center current line when jumping to next search result" })
map("n", "N", "Nzz", { desc = "Center current line when jumping to previous search result" })
map("n", "<leader>BD", ":%bd!<cr>|:Oil<cr>", { desc = "Close all buffers and return to base directory" })
map("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move a selected block down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move a selected block up" })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.ino",
	command = "set filetype=arduino",
})
vim.treesitter.language.register("cpp", "arduino")
