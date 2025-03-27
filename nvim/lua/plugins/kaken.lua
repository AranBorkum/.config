return {
	"octoenergy/kraken.nvim",
	keys = {
		{ "<leader>gt", "<cmd>KLocateTests<cr>", desc = "Locate tests for kraken core" },
	},

	opts = {
		commands = {
			locate_tests = {
				open_command = "vsp", -- command used to open the test file, e.g. "e", "split", "lefta vsp"
			},
		},
	},
}
