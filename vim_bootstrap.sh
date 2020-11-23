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
echo "Updating all git submodules" | tee -a $LOGFILE
git submodule foreach git pull origin master | tee -a $LOGFILE
# now install the submodules
echo "ctrlp" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/ctrlp.vim" "$HOME/.vim/pack/eitas/start/"
echo "surround" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-surround" "$HOME/.vim/pack/eitas/start/"
echo "airline" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-airline" "$HOME/.vim/pack/eitas/start/"
echo "NERDTree" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/nerdtree" "$HOME/.vim/pack/eitas/start/"

echo ">>>>>" | tee -a $LOGFILE


echo "Copying over vim snippets" | tee -a $LOGFILE
cp -r "$PWD/vimsnippets" "$HOME/.vim/"

echo "Completed vim bootstrap" | tee -a $LOGFILE
