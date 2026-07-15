local helpers = require("core.helpers")

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center current line when paging down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center current line when paging up" })
vim.keymap.set("n", "n", "nzz", { desc = "Center current line when jumping to next search result" })
vim.keymap.set("n", "N", "Nzz", { desc = "Center current line when jumping to previous search result" })
vim.keymap.set("n", "<leader>BD", ":%bd!<cr>|:Oil<cr>", { desc = "Close all buffers and return to base directory" })
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move a selected block down", silent = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move a selected block up", silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-c>", "<Esc>", { desc = "C-c behaves like Escape" })
vim.keymap.set("x", "p", '"_dP', { desc = "Paste value from register and keep value in register" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("n", "]q", ":cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { desc = "Previous quickfix item" })

-- LSP stuff
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- In line errors
vim.keymap.set("n", "<leader>gl", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>vt", helpers.toggle_virtual_text, {})

-- Git stuff
vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>", {})
vim.keymap.set("n", "<leader>wt", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", {})

-- Asana
vim.keymap.set("n", "<leader>ASS", "<cmd>AsanaUpdateTicket<cr>", {})
