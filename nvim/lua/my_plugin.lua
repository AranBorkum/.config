local M = {}

function M.prompt()
	vim.ui.input({ prompt = "Enter item name: " }, function(input)
		if input ~= nil and input ~= "" then
			local item_name = input

			vim.ui.input({ prompt = "Enter command: " }, function(input)
				if input ~= nil and input ~= "" then
					local item_method = input
					print(item_name .. " - " .. item_method)
				else
					print("No item name entered.")
				end
			end)

		else
			print("No item name entered.")
		end
	end)
end

function M.open_centered_buffer(content_lines)
	-- Get current editor dimensions
	local width = vim.o.columns
	local height = vim.o.lines

	-- Define buffer dimensions
	local buf_width = math.floor(width * 0.6)
	local buf_height = math.floor(height * 0.5)

	local col = math.floor((width - buf_width) / 2)
	local row = math.floor((height - buf_height) / 2 - 1)

	-- Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Define window options
	local opts = {
		style = "minimal",
		relative = "editor",
		width = buf_width,
		height = buf_height,
		row = row,
		col = col,
		border = "rounded",
	}

	-- Create the floating window
	vim.api.nvim_open_win(buf, true, opts)

	-- Optional: insert some default text
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content_lines)
end

return M
