" Set the runtimepath for vim and all subfolders like colors etc...
set runtimepath^=~/ runtimepath+=~/.vim
" Set the path to the package manager to also be under .vim
" This allows vim and neovim to share the same packages
let &packpath = &runtimepath
" now source the vimrc to load all the VIM settings for neovim
source ~/.vimrc

