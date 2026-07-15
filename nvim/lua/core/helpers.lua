local M = {}

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

M.is_python = function(path)
	return exists(path .. "/pyproject.toml") or exists(path .. "/requirements.txt") or exists(path .. "/setup.py")
end


local is_python = function(path)
	return exists(path .. "/pyproject.toml") or exists(path .. "/requirements.txt") or exists(path .. "/setup.py")
end


function M.toggle_virtual_text()
	local current = vim.diagnostic.config().virtual_text
	if current then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({
			virtual_text = { source = true },
		})
	end
end

return M
