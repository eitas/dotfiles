#!/bin/bash

# setting up vim configuration
# 31-08-2021: Want to start keeping a record of my plugins and why I am using them and what I am considering.  At present I am considering the move to Neovim
# and want to freshen up my use of plugins to get closer to an IDE experience and speed up my navigation around projects.
# In this I am exploring the possibility of moving from YouCompleteMe to Conquer of Completion (coc) as a completion plugin.
# 20-09-2021: Going to go all out with Neovim now and so updating lots of this bootstrap

if [ -z ${LOGFILE+x}  ]; then 
	echo "LOGFILE is not set for neovim_bootstrap.sh, setting it."
	NOW=$(date +"%d-%m-%Y_%H_%M_%S")
	mkdir -p ./logs
	LOGFILE="./logs/neovim_bootstrap_install_$NOW.log"
else
	echo "LOGFILE is set to '$LOGFILE'";
fi

echo "Starting neovim bootstrap" | tee -a $LOGFILE

VIM_PLUGINS_DIR="$HOME/.local/share/nvim/site/pack/eitas/start"
VIM_COLORS_DIR="$HOME/.config/nvim/colors"

echo "Installing color schemes" | tee -a $LOGFILE
mkdir -p $VIM_COLORS_DIR
ln -sf "$PWD/vimcolors/Alduin/colors/alduin.vim" "$VIM_COLORS_DIR/alduin.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/badwolf.vim" "$VIM_COLORS_DIR/badwolf.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/goodwolf.vim" "$VIM_COLORS_DIR/goodwolf.vim"
ln -sf "$PWD/vimcolors/vim-afterglow/colors/afterglow.vim" "$VIM_COLORS_DIR/afterglow.vim"
ln -sf "$PWD/vimcolors/gruvbox/colors/gruvbox.vim" "$VIM_COLORS_DIR/gruvbox.vim"

echo "Installing plugins" | tee -a $LOGFILE
mkdir -p $VIM_PLUGINS_DIR
echo ">>>>>" | tee -a $LOGFILE
echo "Updating all git submodules" | tee -a $LOGFILE
sudo git submodule foreach git pull origin master | tee -a $LOGFILE
# now install the submodules
echo "Installing Vim Plugins"
echo "surround by tpope (https://github.com/tpope/vim-surround)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/vim-surround
sudo cp -r "$PWD/vimplugins/vim-surround" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "airline (https://github.com/vim-airline/vim-airline)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/vim-airline
sudo cp -r "$PWD/vimplugins/vim-airline" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "NERDTree (https://github.com/preservim/nerdtree)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/nerdtree
sudo cp -r "$PWD/vimplugins/nerdtree" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "GitGutter (https://github.com/airblade/vim-gitgutter)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/vim-gitgutter
sudo cp -r "$PWD/vimplugins/vim-gitgutter" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "fugitive (https://github.com/tpope/vim-fugitive)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/vim-fugitive
sudo cp -r "$PWD/vimplugins/vim-fugitive" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "typescript (https://github.com/leafgarland/typescript-vim)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/typescript-vim
sudo cp -r "$PWD/vimplugins/typescript-vim" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "ale (https://github.com/dense-analysis/ale)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/ale
sudo cp -r "$PWD/vimplugins/ale" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
##echo "hardmode" | tee -a $LOGFILE
#sudo cp -r "$PWD/vimplugins/hardmode" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "coc (https://github.com/neoclide/coc.nvim)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/coc.nvim
CWD=$PWD
cd $PWD/vimplugins/coc.nvim
#sudo git checkout release
#sudo git pull
cd $CWD
cp -r "$PWD/vimplugins/coc.nvim" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
##echo "YouCompleteMe" | tee -a $LOGFILE
# cp -r "$PWD/vimplugins/YouCompleteMe" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "fzf (https://github.com/junegunn/fzf)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/fzf
sudo cp -r "$PWD/vimplugins/fzf" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE
echo "fzf.vim (https://github.com/junegunn/fzf.vim)" | tee -a $LOGFILE
sudo rm -rf $VIM_PLUGINS_DIR/fzf.vim
sudo cp -r "$PWD/vimplugins/fzf.vim" "$VIM_PLUGINS_DIR/" | tee -a $LOGFILE

echo ">>>>>" | tee -a $LOGFILE

echo "Neovim" | tee -a $LOGFILE
echo "------" | tee -a $LOGFILE

mkdir -p ~/.config/nvim
cp $PWD/init.vim ~/.config/nvim

# echo "Copying over vim snippets" | tee -a $LOGFILE
# cp -r "$PWD/vimsnippets" "$HOME/.vim/"

echo "Completed neovim bootstrap" | tee -a $LOGFILE
