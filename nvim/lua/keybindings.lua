-- https://github.com/nanotee/nvim-lua-guide#defining-mappings
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('i', '<esc>', '<nop>', {noremap = true})

vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true}) 
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true}) 
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true}) 
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true}) 
-- map <F3> "zyiw:exe "h ".@z.""<CR>
vim.api.nvim_set_keymap('n', 'n', 'nzz', {noremap = false}) 
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {noremap = false}) 
vim.api.nvim_set_keymap('n', '*', '*zz', {noremap = false}) 

vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', {noremap = true}) 
vim.api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<cr>', {noremap = true}) 

