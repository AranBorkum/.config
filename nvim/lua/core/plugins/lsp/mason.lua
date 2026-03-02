return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local extras = {}
			local categories = { "formatters", "linters", "debuggers" }

			for _, lang in pairs(require("config.lsp")) do
				for _, category in ipairs(categories) do
					for _, tool in ipairs(lang[category] or {}) do
						extras[#extras + 1] = tool
					end
				end
			end

			require("mason-tool-installer").setup({
				ensure_installed = extras,
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local lsps = {}
			for _, lang in pairs(require("config.lsp")) do
				for _, tool in ipairs(lang.lsp_servers) do
					lsps[#lsps + 1] = tool.name
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = lsps,
			})
		end,
	},
}
