vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.errorbells = false
vim.opt.scrolloff = 8
vim.opt.fileformat = 'unix'
vim.opt.encoding = 'utf-8'
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- Settings for general formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 120

if not vim.g.vscode then
  vim.opt.colorcolumn = "80"
  vim.opt.cmdheight = 2
  vim.opt.path = vim.opt.path + '**'

  vim.opt.wildmode = {'longest','list','full'}
  vim.opt.wildmenu = true
  vim.opt.wildignore = vim.opt.wildignore + '*.pyc'
  vim.opt.wildignore = vim.opt.wildignore + '*.swp'
  vim.opt.wildignore = vim.opt.wildignore + '*_build/*'
  vim.opt.wildignore = vim.opt.wildignore + '**/node_modules/*'
  vim.opt.wildignore = vim.opt.wildignore + '**/.git/*'

  vim.opt.listchars = {eol = '↲', tab = '▸ ', trail = '·'}
  vim.opt.completeopt = {'menu','menuone','noselect'}

  vim.g['terraform_fmt_on_save'] = 1
end
