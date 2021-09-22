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

VIM_COLORS_DIR="$HOME/.config/nvim/colors"

echo "Installing color schemes" | tee -a $LOGFILE
mkdir -p $VIM_COLORS_DIR
ln -sf "$PWD/vimcolors/Alduin/colors/alduin.vim" "$VIM_COLORS_DIR/alduin.vim"
ln -sf "$PWD/vimcolors/badwolf/colors/badwolf.vim" "$VIM_COLORS_DIR/badwolf.vim"
ln -sf "$PWD/vimcolors/vim-afterglow/colors/afterglow.vim" "$VIM_COLORS_DIR/afterglow.vim"
ln -sf "$PWD/vimcolors/gruvbox/colors/gruvbox.vim" "$VIM_COLORS_DIR/gruvbox.vim"
ln -sf "$PWD/vimcolors/vim-colors-solarized/colors/solarized.vim" "$VIM_COLORS_DIR/solarized.vim"

echo ">>>>>" | tee -a $LOGFILE

echo "Neovim" | tee -a $LOGFILE
echo "------" | tee -a $LOGFILE

echo "symlinking init.vim" | tee -a $LOGFILE
mkdir -p ~/.config/nvim
ln -sf "$PWD/init.vim" "$HOME/.config/nvim" | tee -a $LOGFFILE

# echo "Copying over vim snippets" | tee -a $LOGFILE
# cp -r "$PWD/vimsnippets" "$HOME/.vim/"

echo "Completed neovim bootstrap" | tee -a $LOGFILE
