vim.g.mapleader = ' '

local is_vscode = vim.g.vscode ~= nil

require('globals')
require('sets')
require('keybindings')

if not is_vscode then
  vim.opt.runtimepath:append(',~/.config/nvim/plugin')

  -- Bootstrap lazy.nvim (self-installs on first run)
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup(require("plugins"))

  require('autocmds')
  print("Neovim config loaded!")
  vim.o.termguicolors = true
  vim.cmd.colorscheme("gruvbox")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/venv/bin/python')
end
