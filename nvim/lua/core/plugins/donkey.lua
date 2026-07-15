return {
	"AranBorkum/donkey.nvim",
	dev = true,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("donkey").setup()
	end,
}
