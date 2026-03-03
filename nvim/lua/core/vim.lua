local virtual_text_enabled = false

vim.g.mapleader = " "

vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.exrc = true
vim.opt.termguicolors = true

vim.keymap.set("n", "gl", vim.diagnostic.open_float)

vim.keymap.set("n", "<leader>tv", function()
	virtual_text_enabled = not virtual_text_enabled

	vim.diagnostic.config({
		virtual_text = virtual_text_enabled,
	})

	if virtual_text_enabled then
		print("Virtual text ON")
	else
		print("Virtual text OFF")
	end
end, { desc = "Toggle virtual text diagnostics" })
