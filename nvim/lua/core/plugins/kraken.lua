return {
	"octoenergy/kraken.nvim",
	branch = "get-translation",
	keys = {
		{
			"<leader>lt",
			"<cmd>KLocateTests<cr>",
			desc = "Locate test file(s)",
		},
		{
			"<leader>DD",
			"<cmd>KDataDogEvent<cr>",
			desc = "Open event in Datadog",
		}
	},
	cond = function()
      -- Check if the current directory contains your specific project path
      local cwd = vim.fn.getcwd()
      return cwd:find("kraken%-core") ~= nil
    end,
	dev = true,
	lazy = false,
	opts = {
		commands = {
			locate_tests = {
				open_command = "lefta vsp",
				picker = "snacks",
			},
		},
	},
}
