vim.g.mapleader = ' '

local is_vscode = vim.g.vscode ~= nil

require('globals')
require('sets')
require('keybindings')

if is_vscode then
  require('vscode_keybindings')
else
  vim.opt.runtimepath:append(',~/.config/nvim/plugin')

  require('plugins')
  require('lspconfig_setup')
  require('treesitter')
  require('conf.telescope')
  require('conf.nerdtree')

  require('autocmds')
  print("Neovim config loaded!")
  vim.o.termguicolors = true
  vim.cmd.colorscheme("gruvbox")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  vim.g.python3_host_prog='/home/max/.config/nvim/venv/bin/python'
end
