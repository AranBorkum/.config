vim.api.nvim_create_user_command("CopyFilePath", function()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		print("No file path available (maybe an unsaved buffer?)")
		return
	end
	vim.fn.setreg("+", filepath)
	print("Copied file path to clipboard: " .. filepath)
end, {})

vim.api.nvim_create_user_command("CopyFilePathNoHome", function()
	local full_path = vim.fn.expand("%:p")
	if full_path == "" then
		print("No file path available (maybe an unsaved buffer?)")
		return
	end

	local home = vim.fn.expand("~")
	local relative_path = full_path:gsub("^" .. vim.pesc(home) .. "/", "")

	vim.fn.setreg("+", relative_path)
	print("Copied relative file path to clipboard: " .. relative_path)
end, {})

vim.keymap.set(
	"n",
	"<leader>Yp",
	"<cmd>CopyFilePathNoHome<CR>",
	{ desc = "Copy file path (relative to $HOME) to + register" }
)

vim.keymap.set("n", "<leader>YP", "<cmd>CopyFilePath<CR>", { desc = "Copy file path to + register" })
