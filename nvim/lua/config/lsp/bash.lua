---@type ToolingConfig
return {
	formatters = { "shfmt" },
	linters = { "shellcheck" },
	debuggers = {},
	lsp_servers = {
		{
			name = "bashls",
			settings = {},
		},
	},
}
