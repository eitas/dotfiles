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
vim.opt.colorcolumn = "80"
vim.opt.cmdheight = 2
vim.opt.fileformat = 'unix'
vim.opt.encoding = 'utf-8'
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'
vim.opt.path = vim.opt.path + '**'

-- Not sure how much I am using the wildmenu these days
vim.opt.wildmode = {'longest','list','full'}
vim.opt.wildmenu = true
vim.opt.wildignore = vim.opt.wildignore + '*.pyc'  
vim.opt.wildignore = vim.opt.wildignore + '*.swp'  
vim.opt.wildignore = vim.opt.wildignore + '*_build/*'  
vim.opt.wildignore = vim.opt.wildignore + '**/node_modules/*'  
vim.opt.wildignore = vim.opt.wildignore + '**/.git/*'  

-- Settings for general formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 120

-- new setting on 13/11/2021 lets see what we get
-- This is similar to Jess Archer and that looked quite nice
vim.opt.listchars = {eol = '↲', tab = '▸ ', trail = '·'}

vim.g['airline_powerline_fonts'] = 1
-- let g:airline_powerline_fonts = 1

