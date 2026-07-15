return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"RRethy/nvim-treesitter-endwise",
		},
		config = function()
			local nvim_treesitter = require("nvim-treesitter")
			nvim_treesitter.setup {
				install_dir = vim.fn.stdpath('data') .. '/site'
			}

			local parsers = {
				"bash",
				"helm",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"rust",
				"scala",
				"sql",
				"terraform",
				"toml",
				"tsx",
				"typescript",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			local patterns = {}
			for _, parser in ipairs(parsers) do
				nvim_treesitter.install(parser)
				local parse_patterns = vim.treesitter.language.get_filetypes(parser)
				for _, pp in ipairs(parse_patterns) do
					table.insert(patterns, pp)
				end
			end

			vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.wo[0][0].foldmethod = 'expr'

			vim.api.nvim_create_autocmd('FileType', {
				pattern = patterns,
				callback = function()
					vim.treesitter.start()
				end,
			})

			local ts_move = require("nvim-treesitter-textobjects.move")
			local function map_move(keymaps, func, desc_prefix)
				for key, query in pairs(keymaps) do
					vim.keymap.set({ "n", "x", "o" }, key, function()
						-- The second argument "textobjects" tells Treesitter which query group to use
						func(query, "textobjects")
					end, { desc = desc_prefix .. " " .. query })
				end
			end

			map_move({
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
				["]f"] = "@call.name",
			}, ts_move.goto_next_start, "Next start")

			map_move({
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
				["]t"] = "@return_type",
			}, ts_move.goto_next_end, "Next end")

			map_move({
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[f"] = "@call.name",
			}, ts_move.goto_previous_start, "Prev start")

			map_move({
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
				["[t"] = "@return_type",
				["[i"] = "@import_statement",
			}, ts_move.goto_previous_end, "Prev end")

			require("nvim-ts-autotag").setup({
				aliases = {
					htmldjango = "html",
				},
			})
		end
	}
}
