vim.g.mapleader = ' '
require('basic')
require('plugins')
require('sets')
require('keybindings')
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.terraformls.setup{}
require('autocmds')
require('conf.telescope')
require('conf.nerdtree')
require('conf.mason')
require('conf.nvim-cmp')
require('conf.treesitter')

vim.o.termguicolors = true
vim.cmd.colorscheme("gruvbox")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
