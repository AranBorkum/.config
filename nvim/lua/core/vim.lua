vim.g.mapleader = " "

vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.exrc = true
vim.opt.termguicolors = true

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
