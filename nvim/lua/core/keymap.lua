vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center current line when paging down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center current line when paging up" })
vim.keymap.set("n", "n", "nzz", { desc = "Center current line when jumping to next search result" })
vim.keymap.set("n", "N", "Nzz", { desc = "Center current line when jumping to previous search result" })
vim.keymap.set("n", "<leader>BD", ":%bd!<cr>|:Oil<cr>", { desc = "Close all buffers and return to base directory" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move a selected block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move a selected block up" })
vim.keymap.set({ "n", "i", "v" }, "<C-c>", "<Esc>", { desc = "C-c behaves like Escape" })
vim.keymap.set("x", "p", '"_dP', { desc = "Paste value from register and keep value in register" })
vim.keymap.set("x", "<M-j>", "<cmd>cnext<cr>", { desc = "Go to next item in quick fix list " })
vim.keymap.set("x", "<M-k>", "<cmd>cprev<cr>", { desc = "Go to previous item in quick fix list " })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})

-- LSP stuff
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- In line errors
vim.keymap.set("n", "<leader>gl", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>vt", function()
	local current = vim.diagnostic.config().virtual_text
	if current then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({
			virtual_text = { source = true }
		})
	end
end)

-- Git stuff
vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>", {})

-- Arduino stuff that I don't think actually works
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.ino",
	command = "set filetype=arduino",
})
vim.treesitter.language.register("cpp", "arduino")
