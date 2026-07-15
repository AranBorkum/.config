local function get_step_text()
	local line = vim.api.nvim_get_current_line()

	local step_text = line:match("^%s*[Gg]iven%s+(.*)") or
		line:match("^%s*[Ww]hen%s+(.*)") or
		line:match("^%s*[Tt]hen%s+(.*)") or
		line:match("^%s*[Aa]nd%s+(.*)") or
		line:match("^%s*[Bb]ut%s+(.*)")

	return step_text
end

local function step_to_pattern(step_text)
	local pattern = step_text:gsub("([().%%+*?[%]^$-])", "\\%1")
	pattern = pattern:gsub('"[^"]*"', '"[^"]*"')
	pattern = pattern:gsub("%d+", "\\d+")
	return pattern
end

local function find_step_definition()
	local step_text = get_step_text()

	if not step_text or step_text == "" then
		vim.notify("No Gherkin step found on current line", vim.log.levels.WARN)
		return
	end

	local pattern = step_to_pattern(step_text)

	local escaped_pattern = pattern:gsub("'", "'\\''")

	local search_path = vim.env.GHERKIN_SEARCH_PATH
	local cmd = string.format("rg --vimgrep '%s' %s", escaped_pattern, search_path)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()

	if result == "" then
		vim.notify("No step definition found for: " .. step_text, vim.log.levels.WARN)
		return
	end

	local qf_entries = {}
	for filename, lnum, col, text in result:gmatch("([^:]+):(%d+):(%d+):(.-)[\n]") do
		if filename:match("%.py$") then
			table.insert(qf_entries, {
				filename = filename,
				lnum = tonumber(lnum),
				col = tonumber(col),
				text = text
			})
		end
	end

	if #qf_entries == 0 then
		vim.notify("No step definition found for: " .. step_text, vim.log.levels.WARN)
	elseif #qf_entries == 1 then
		vim.fn.setqflist(qf_entries)
		vim.cmd("cfirst")
	else
		vim.fn.setqflist(qf_entries)
		vim.cmd("copen")
	end
end

vim.api.nvim_buf_create_user_command(0, "FindCucumberStep", find_step_definition, {
	desc = "Find Cucumber step definition"
})

-- vim.keymap.set("n", "<leader>gd", "<cmd>:FindCucumberStep<cr>")
