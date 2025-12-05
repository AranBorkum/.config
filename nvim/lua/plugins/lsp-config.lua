return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"debugpy",
				"ruff",
			},
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pylsp",
					"ruff",
					"bashls",
					"ts_ls",
					"html",
					"clangd",
					"rust_analyzer",
					"arduino_language_server",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local config = vim.lsp.config

			config("lua_ls", {})
			config("pylsp", { capabilities = capabilities, cmd_env = { VIRTUAL_ENV = ".venv" } })
			config("bashls", { capabilities = capabilities })
			config("ts_ls", { capabilities = capabilities })
			config("html", { capabilities = capabilities })
			config("clangd", { capabilities = capabilities })

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		end,
	},
}
