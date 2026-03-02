local neotest_python = require("neotest-python")
local pytest_args = vim.g.test_cmd or { "-vv" }

return neotest_python({
	dap = { justMyCode = true, django = true },
	args = pytest_args,
	runner = "pytest",
	python = ".venv/bin/python",
})
