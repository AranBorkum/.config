---@type ToolingConfig
return {
	formatters = {},
	linters = {},
	debuggers = {},
	lsp_servers = {
		{
			name = "cucumber_language_server",
			settings = {
				cucumber = {
					features = { "**/*.feature" },
					glue = { "tests/**/*.py" },
				},
			},
		},
	},
}
