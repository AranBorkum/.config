return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		---@diagnostic disable-next-line: missing-parameter
		harpoon:setup()
		local function map(lhs, rhs, opts)
			vim.keymap.set("n", lhs, rhs, opts or {})
		end
		map("<leader>ha", function() harpoon:list():add() end)
		map("<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
		map("<C-h>", function() harpoon:list():select(1) end)
		map("<C-j>", function() harpoon:list():select(2) end)
		map("<C-k>", function() harpoon:list():select(3) end)
		map("<C-l>", function() harpoon:list():select(4) end)
	end
}
