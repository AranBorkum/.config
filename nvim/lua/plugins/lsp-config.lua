return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed =  { "lua_ls", "pylsp", "bashls", "ts_ls", "html", "ruff" }
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.pylsp.setup({capabilities = capabilities})
			lspconfig.bashls.setup({capabilities = capabilities})
			lspconfig.ts_ls.setup({capabilities = capabilities})
			lspconfig.html.setup({capabilities = capabilities})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		end
	}
}
