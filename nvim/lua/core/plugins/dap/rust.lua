return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	lazy = false,
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		local extension_path = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/")
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb" .. (vim.fn.has("mac") == 1 and ".dylib" or ".so")

		vim.g.rustaceanvim = {
			dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}
	end,
}
