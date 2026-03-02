return {
	"mfussenegger/nvim-dap-python",
	ft = "python",
	dependencies = {
		"mfussenegger/nvim-dap",
		"williamboman/mason.nvim",
	},
	opts = { rocks = { enables = false } },
	dev = true,
	config = function()
		local path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
		require("dap-python").setup(path)
	end,
}
