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
		config = function()
			require("telescope").load_extension("import")
		end,
	},
}
