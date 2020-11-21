#!/bin/bash

# setting up vim configuration
echo "Starting vim bootstrap" | tee -a $LOGFILE

VIM_PLUGINS_DIR="$HOME/.vim/pack/eitas/start"

echo "Installing color schemes" | tee -a $LOGFILE
mkdir -p ~/.vim/colors
ln -sf "$PWD/vimcolors/Alduin/colors/alduin.vim" "$HOME/.vim/colors/alduin.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/badwolf.vim" "$HOME/.vim/colors/badwolf.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/goodwolf.vim" "$HOME/.vim/colors/goodwolf.vim"
ln -sf "$PWD/vimcolors/vim-afterglow/colors/afterglow.vim" "$HOME/.vim/colors/afterglow.vim"

echo "Installing plugins" | tee -a $LOGFILE
mkdir -p ~/.vim/pack/eitas/start
echo ">>>>>" | tee -a $LOGFILE
echo "ctrlp" | tee -a $LOGFILE
mkdir -p ~/.vim/pack/eitas/start/ctrlp/plugin
cp "$PWD/vimplugins/ctrlp.vim/plugin/ctrlp.vim" "$HOME/.vim/pack/eitas/start/ctrlp/plugin/ctrlp.vim"
echo "surround" | tee -a $LOGFILE
mkdir -p ~/.vim/pack/eitas/start/surround/plugin
echo ">>>>>" | tee -a $LOGFILE
cp "$PWD/vimplugins/vim-surround/plugin/surround.vim" "$HOME/.vim/pack/eitas/start/surround/plugin/surround.vim"

echo "Completed vim bootstrap" | tee -a $LOGFILE
