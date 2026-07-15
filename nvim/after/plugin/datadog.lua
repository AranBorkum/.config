-- 1. Helper: URL Encode
local function url_encode(str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "+")
	end
	return str
end

-- 2. Helper: Open Datadog with a specific query string
local function open_datadog_with_query(query_str)
	if not query_str or query_str == "" then
		print("Invalid Datadog query string.")
		return
	end

	local dd_base_url = "https://app.datadoghq.eu/logs"

	-- Calculate timestamps (Now - 24h)
	local now_ms = os.time() * 1000
	local one_day_ms = 24 * 60 * 60 * 1000
	local start_ms = now_ms - one_day_ms

	local encoded_query = url_encode(string.format("@event:%s", query_str))

	-- Construct URL
	local url = string.format("%s?query=%s&from_ts=%d&to_ts=%d&live=true", dd_base_url, encoded_query, start_ms, now_ms)

	print("Opening Datadog for: " .. query_str)

	-- Open Browser
	if vim.ui and vim.ui.open then
		vim.ui.open(url)
	else
		local opener = (vim.fn.has("macunix") == 1 and "open")
			or (vim.fn.has("win32") == 1 and "explorer.exe")
			or "xdg-open"
		os.execute(string.format("%s '%s' > /dev/null 2>&1", opener, url))
	end
end

-- 3. Helper: Attempt to extract a quoted string from a specific line of text
local function extract_quoted_string(line, col)
	-- If col is nil, we just return the first quoted string we find
	if not col then
		return line:match("['\"](.-)['\"]")
	end

	-- If col is provided, we ensure the cursor is strictly inside the quotes
	for start_idx, quote, content in line:gmatch("()(['\"])(.-)%2") do
		local end_idx = start_idx + #quote + #content + #quote - 1
		if col + 1 >= start_idx and col + 1 <= end_idx then
			return content
		end
	end
	return nil
end

-- 4. Main Function
local function open_datadog_event_smart()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local current_line = vim.api.nvim_get_current_line()

	-- STRATEGY A: Check if we are physically sitting on a string
	local direct_match = extract_quoted_string(current_line, col)
	if direct_match then
		open_datadog_with_query(direct_match)
		return
	end

	-- STRATEGY B: Use LSP to find definition of the word under cursor
	local cword = vim.fn.expand("<cword>")
	if cword == "" then
		print("No word under cursor.")
		return
	end

	print("Looking up definition for '" .. cword .. "'...")

	local params = vim.lsp.util.make_position_params()

	-- Request the definition
	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
		if err or not result or vim.tbl_isempty(result) then
			-- FALLBACK: If no LSP result, just use the word itself
			print("LSP definition not found. Using word: " .. cword)
			open_datadog_with_query(cword)
			return
		end

		-- Handle both single Location and Location[]
		local location = result[1] or result

		-- Handle LocationLink (used by some LSPs) vs standard Location
		local uri = location.targetUri or location.uri
		local range = location.targetRange or location.range

		if not uri or not range then
			open_datadog_with_query(cword)
			return
		end

		-- We need to read the line at the definition
		local target_line_text = ""
		local bufnr = vim.uri_to_bufnr(uri)

		if vim.api.nvim_buf_is_loaded(bufnr) then
			-- Read from loaded buffer
			local lines = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range.start.line + 1, false)
			target_line_text = lines[1] or ""
		else
			-- Read from file on disk
			local fname = vim.uri_to_fname(uri)
			local file_lines = vim.fn.readfile(fname)
			-- vim.fn.readfile returns a list, range.start.line is 0-indexed
			target_line_text = file_lines[range.start.line + 1] or ""
		end

		-- Try to find a string value in the definition line
		-- e.g., const MY_EVENT = "user_login" -> extracts "user_login"
		local resolved_value = extract_quoted_string(target_line_text, nil)

		if resolved_value then
			print("Resolved '" .. cword .. "' to '" .. resolved_value .. "'")
			open_datadog_with_query(resolved_value)
		else
			-- If we found the definition but it wasn't a string constant,
			-- fallback to the variable name.
			print("Definition found but no string value. Using: " .. cword)
			open_datadog_with_query(cword)
		end
	end)
end

-- Create the command
vim.api.nvim_create_user_command("DDEvent", open_datadog_event_smart, {})

-- Optional: Keymap
vim.keymap.set("n", "<leader>DD", open_datadog_event_smart, { desc = "Open Datadog event (String or Definition)" })
