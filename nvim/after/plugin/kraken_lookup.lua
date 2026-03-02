local function open_closest_match_split()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local cur_file = vim.api.nvim_buf_get_name(0)
	local line = vim.api.nvim_get_current_line()

	-- Find quoted string under cursor
	local found = nil
	for start_idx, quote, content in line:gmatch("()(['\"])(.-)%2") do
		local end_idx = start_idx + #quote + #content + #quote - 1
		if col + 1 >= start_idx and col + 1 <= end_idx then
			found = content
			break
		end
	end

	if not found then
		print("No quoted string under cursor")
		return
	end

	-- Directory to search in
	local search_dir = "src/octoenergy/plugins/common/i18n/locales/"

	-- Run ripgrep for all matches
	local handle = io.popen(string.format("rg --vimgrep '%s' %s", found, search_dir))
	local result = handle:read("*a")
	handle:close()

	if result == "" then
		print("No files found containing: " .. found)
		return
	end

	-- Parse matches into a table
	local matches = {}
	for filename, line_num, col_num in result:gmatch("([^:]+):(%d+):(%d+):") do
		table.insert(matches, {
			filename = filename,
			line = tonumber(line_num),
			col = tonumber(col_num),
		})
	end

	if #matches == 0 then
		print("No valid matches found")
		return
	end

	-- Function to calculate "distance" from current cursor position
	local function distance(m)
		if cur_file == m.filename then
			return math.abs(row - m.line)
		else
			return math.huge -- other files are less preferred
		end
	end

	-- Find the closest match
	table.sort(matches, function(a, b)
		return distance(a) < distance(b)
	end)

	local closest = matches[1]
	-- Open in vertical split
	vim.cmd(string.format("vsplit +%d %s", closest.line, closest.filename))
	vim.fn.cursor(closest.line, closest.col)
end

vim.api.nvim_create_user_command("OpenQuotedClosestSplit", open_closest_match_split, {})

-- vim.keymap.set("n", "<leader>gt", function()
-- 	vim.cmd("OpenQuotedClosestSplit")
-- end, { noremap = true, silent = true })
