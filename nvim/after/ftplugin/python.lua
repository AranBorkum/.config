local convert_file_path_to_dotted_path = function(file_path)
	return string.gsub(file_path, "/", ".")
end

local get_current_file_dotted_path = function()
	return convert_file_path_to_dotted_path(vim.fn.expand("%:.:r"))
end

local convert_dotted_path_to_import_statement = function(path)
	-- Split the line into parts by the dot separator
	local parts = {}
	for part in string.gmatch(path, "[^.]+") do
		if part ~= "src" then
			table.insert(parts, part)
		end
	end

	-- Ensure there are enough parts to form a valid import statement
	if #parts < 2 then
		error("Invalid module path")
	end

	-- Get the last part for the import statement
	local item = table.remove(parts)
	-- Join the remaining parts for the from statement
	local module_path = table.concat(parts, ".")

	-- Construct the new line
	local new_line = string.format("from %s import %s", module_path, item)

	return new_line
end

vim.api.nvim_create_user_command("FormatLineAsImportStatement", function(_)
	-- Get the current line content
	local line = vim.api.nvim_get_current_line()

	local importStatement = convert_dotted_path_to_import_statement(line)

	vim.fn.setreg('"', importStatement)
end, {})

vim.keymap.set("n", "<leader>yp", function()
	local import_path = get_current_file_dotted_path()
	vim.fn.setreg('"', import_path)
end)

vim.keymap.set("n", "<leader>Yp", function ()
	local file_path = vim.fn.expand("%")	
	vim.fn.setreg("+", file_path)
end)

vim.keymap.set("n", "<leader>F", function()
	local import_path = get_current_file_dotted_path()
	local import_statement = convert_dotted_path_to_import_statement(import_path)
	vim.fn.setreg('"', import_statement)
end)
