return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		default_file_explorer = true,
	},
	keys = {
		{ "<C-n>", "<cmd>Oil<cr>", desc = "Open Oil explorer" },
	},
}
