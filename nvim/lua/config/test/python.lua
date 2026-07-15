return require("neotest-python")({
	dap = { justMyCode = true, django = true },
	args = vim.g.test_cmd or { "-vv" },
	runner = "pytest",
	python = ".venv/bin/python",
})
