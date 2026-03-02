local M = {}

local path = vim.fn.stdpath("config") .. "/lua/config/lsp"
local files = vim.fn.readdir(path)

for _, file in ipairs(files) do
  if file ~= "init.lua" and file:match("%.lua$") then
    local name = file:gsub("%.lua$", "")
    M[name] = require("config.lsp." .. name)
  end
end

return M

