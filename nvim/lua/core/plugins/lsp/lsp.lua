return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		requires = {
			{ "saghen/blink.cmp" },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for _, lang in pairs(require("config.lsp")) do
				for _, lsp in pairs(lang.lsp_servers) do
					vim.lsp.config(
						lsp.name,
						vim.tbl_deep_extend("force", { capabilities = capabilities }, lsp.settings)
					)
					vim.lsp.enable(lsp.name)
				end
			end
		end,
	},
}
