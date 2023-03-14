vim.g.mapleader = ' '
require('basic')
require('plugins')
require('sets')
require('keybindings')
require('autocmds')
require'lspconfig'.pyright.setup{}
require('conf.telescope')
require('conf.nerdtree')
require('conf.nvim-cmp')
require('conf.mason')

vim.o.termguicolors = true
vim.cmd("colorscheme gruvbox")
