vim.cmd('augroup vimrc-incsearch-highlight')
vim.cmd('autocmd!')
vim.cmd('autocmd CmdlineEnter /,? :set hlsearch')
vim.cmd('autocmd CmdlineLeave /,? :set nohlsearch')
vim.cmd('augroup END')

vim.cmd('autocmd BufRead, BufNewFile *.py, *.c, *.h match BadWhitespace /\\s\\+$/')
vim.cmd("autocmd BufWritePost *.py execute ':Black'i")

