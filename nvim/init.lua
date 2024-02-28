vim.g.mapleader = ' '
require('basic')
require('plugins')
require('sets')
require('keybindings')
require('conf.mason')
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.bashls.setup{}
lspconfig.terraformls.setup{}
require('autocmds')
require('conf.nvim-cmp')
require('conf.telescope')
require('conf.nerdtree')
require('conf.treesitter')

vim.o.termguicolors = true
vim.cmd.colorscheme("gruvbox")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
