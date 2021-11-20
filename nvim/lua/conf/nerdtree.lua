-- configuration for Nerdtree
-- https://github.com/preservim/nerdtree
-- adapted from Jess Archer: https://github.com/jessarcher/dotfiles/blob/master/nvim/plugins/nerdtree.vim
-- Need to consult the docs: https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt

vim['NERDTreeShowHidden'] = 1
-- vim['NERDTreeMinimalUI'] = 1

vim.g['NERDTreeDirArrowExpandable'] = '▹'
vim.g['NERDTreeDirArrowCollapsible'] = '▿'

-- My Lua is not strong enough yet to figure out how to write Jess's NERDTree key binding below in Lua
-- So just going to execute Vimscript for now
vim.api.nvim_exec(
[[
nnoremap <expr> <leader>n g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nmap <leader>N :NERDTreeFind<CR>

autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
]], true)
--vim.api.nvim_set_keymap('n', '<leader>n', "g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'", {noremap = true})

