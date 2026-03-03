local M = {}

local path = vim.fn.stdpath("config") .. "/lua/core/plugins/lsp"
local files = vim.fn.readdir(path)

for _, file in ipairs(files) do
	if file ~= "init.lua" and file:match("%.lua$") then
		local name = file:gsub("%.lua$", "")
		table.insert(M, require("core.plugins.lsp." .. name))
	end
end

return M
