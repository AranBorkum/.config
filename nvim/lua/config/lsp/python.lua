return {
	formatters = { "ruff" },
	linters = {},
	debuggers = { "debugpy" },
	lsp_servers = {
		{
			name = "pyright",
			settings = {
				cmd_env = { VIRTUAL_ENV = ".venv" },
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			}
		},
		{
			name = "ruff",
			settings = {
				cmd_env = { VIRTUAL_ENV = ".venv" },
				init_options = {
					settings = {
						format = { enable = true },
					},
				},
				on_attach = function(client)
					client.server_capabilities.completionProvider = nil
					client.server_capabilities.hoverProvider = false
				end,
			}
		}
	}
}
