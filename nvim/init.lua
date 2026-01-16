vim.g.mapleader = ' '
vim.opt.runtimepath:append(',~/.config/nvim/plugin')
--require('basic')
require('globals')
require('sets')
require('keybindings')

require('plugins')

require('lspconfig_setup')
require('treesitter')
require('conf.telescope')
--require('conf.nvim-cmp')
require('conf.nerdtree')
--require('conf.mason')
--require('conf.trello')

require('autocmds')
vim.o.termguicolors = true
vim.cmd.colorscheme("gruvbox")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

