return {
	{
		"nvim-telescope/telescope.nvim",
	},
	{
		"piersolenski/telescope-import.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		keys = {
			{ "<space>fi", "<cmd>Telescope import<cr>", desc = "Imports" },
		},
	},
}
