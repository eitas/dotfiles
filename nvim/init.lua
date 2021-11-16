vim.g.mapleader = ' '
require('basic')
require('plugins')
require('sets')
require('keybindings')
require('autocmds')
require'lspconfig'.pyright.setup{}
require('conf.telescope')

vim.o.termguicolors = true
vim.cmd("colorscheme gruvbox")
