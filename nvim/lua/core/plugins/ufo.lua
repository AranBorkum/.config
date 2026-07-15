return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		vim.opt.fillchars = {
			foldopen = "",
			foldclose = "",
		}

		require("ufo").setup({
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0

				for _, chunk in ipairs(virtText) do
					local text = chunk[1]
					local hl = chunk[2]
					local chunkWidth = vim.fn.strdisplaywidth(text)

					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						text = truncate(text, targetWidth - curWidth)
						table.insert(newVirtText, { text, hl })
						break
					end

					curWidth = curWidth + chunkWidth
				end

				table.insert(newVirtText, { suffix, "Comment" })
				return newVirtText
			end,
		})
	end,
}
