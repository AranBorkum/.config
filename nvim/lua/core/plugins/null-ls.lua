return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = true,
			sources = {
				-- Import Ruff from extras
				require("none-ls.diagnostics.ruff"),
				require("none-ls.formatting.ruff").with({
					extra_args = { "--fix" },
				}),
				null_ls.builtins.diagnostics.sqlfluff.with({
					extra_args = { "--dialect", "postgres" },
				}),
				null_ls.builtins.formatting.sql_formatter.with({
					extra_args = { "--dialect", "postgres" },
				}),
			},
		})
	end,
}
