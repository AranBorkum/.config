return {
	"octoenergy/kraken.nvim",
	-- branch = "add-paste-import-statement-command",
	keys = {
		{
			"<leader>lt",
			"<cmd>KLocateTests<cr>",
			desc = "Locate test file(s)",
		},
	},
	cond = function()
		-- Check if the current directory contains your specific project path
		local cwd = vim.fn.getcwd()
		return cwd:find("kraken%-core") ~= nil
	end,
	lazy = false,
	opts = {
		commands = {
			locate_tests = {
				open_command = "lefta vsp",
			},
		},
	},
}
