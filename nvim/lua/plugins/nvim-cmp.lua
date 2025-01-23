return {
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	config = function ()
		local cmp = require("cmp")

		cmp.setup({
			completion = {
				completeopt = "menu,noselect",
			},
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
				},
			}),
		})
	end
}
