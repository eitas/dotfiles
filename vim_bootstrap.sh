#!/bin/bash

# setting up vim configuration
# 31-08-2021: Want to start keeping a record of my plugins and why I am using them and what I am considering.  At present I am considering the move to Neovim
# and want to freshen up my use of plugins to get closer to an IDE experience and speed up my navigation around projects.
# In this I am exploring the possibility of moving from YouCompleteMe to Conquer of Completion (coc) as a completion plugin.

if [ -z ${LOGFILE+x}  ]; then 
	echo "LOGFILE is not set for vim_bootstrap.sh, setting it."
	NOW=$(date +"%d-%m-%Y_%H_%M_%S")
	mkdir -p ./logs
	LOGFILE="./logs/vim_bootstrap_install_$NOW.log"
else
	echo "LOGFILE is set to '$LOGFILE'";
fi

echo "Starting vim bootstrap" | tee -a $LOGFILE

VIM_PLUGINS_DIR="$HOME/.vim/pack/eitas/start"

echo "Installing color schemes" | tee -a $LOGFILE
mkdir -p ~/.vim/colors
ln -sf "$PWD/vimcolors/Alduin/colors/alduin.vim" "$HOME/.vim/colors/alduin.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/badwolf.vim" "$HOME/.vim/colors/badwolf.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/goodwolf.vim" "$HOME/.vim/colors/goodwolf.vim"
ln -sf "$PWD/vimcolors/vim-afterglow/colors/afterglow.vim" "$HOME/.vim/colors/afterglow.vim"
ln -sf "$PWD/vimcolors/gruvbox/colors/gruvbox.vim" "$HOME/.vim/colors/gruvbox.vim"

echo "Installing plugins" | tee -a $LOGFILE
mkdir -p ~/.vim/pack/eitas/start
echo ">>>>>" | tee -a $LOGFILE
echo "Updating all git submodules" | tee -a $LOGFILE
git submodule foreach git pull origin master | tee -a $LOGFILE
# now install the submodules
echo "ctrlp" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/ctrlp.vim" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "surround" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-surround" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "airline" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-airline" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "NERDTree" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/nerdtree" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "GitGutter" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-gitgutter" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "fugitive" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/vim-fugitive" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "typescript" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/typescript-vim" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "hardmode" | tee -a $LOGFILE
cp -r "$PWD/vimplugins/hardmode" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "coc" | tee -a $LOGFILE
CWD=$PWD
cd $PWD/vimplugins/coc.nvim
git checkout release
cd $CWD
cp -r "$PWD/vimplugins/coc.nvim" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
##echo "YouCompleteMe" | tee -a $LOGFILE
# cp -r "$PWD/vimplugins/YouCompleteMe" "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE
echo "fzf.vim" | tee -a $LOGFILE
FILE_LOCATION="$PWD/vimplugins/fzf\.vim" 
cp -r $FILE_LOCATION "$HOME/.vim/pack/eitas/start/" | tee -a $LOGFILE

echo ">>>>>" | tee -a $LOGFILE


# echo "Copying over vim snippets" | tee -a $LOGFILE
# cp -r "$PWD/vimsnippets" "$HOME/.vim/"

echo "Completed vim bootstrap" | tee -a $LOGFILE
