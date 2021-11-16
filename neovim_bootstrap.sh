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

# --------------------------------------------------------------------------------
# Setup Colors
# --------------------------------------------------------------------------------
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
# --------------------------------------------------------------------------------
# Init.vim (or .lua when I get to that)
# --------------------------------------------------------------------------------
# echo "symlinking init.vim" | tee -a $LOGFILE
echo "symlinking init.lua" | tee -a $LOGFILE
NVIM_DIR="$HOME/.config/nvim"
mkdir -p $NVIM_DIR
# ln -sf "$PWD/nvim/init.vim" "$NVIM_DIR/init.vim" | tee -a $LOGFFILE
ln -sf "$PWD/nvim/init.lua" "$NVIM_DIR/init.lua" | tee -a $LOGFFILE

# check this out https://github.com/nanotee/nvim-lua-guide
# --------------------------------------------------------------------------------
# Lua modules
# --------------------------------------------------------------------------------
echo "Setting up Lua and Lua modules" | tee -a $LOGFILE
LUA_DIR="$HOME/.config/nvim/lua"
mkdir -p $LUA_DIR
LUA_FILES="$PWD/nvim/lua/*.lua"
for file_and_path in $LUA_FILES; do
  FILE=$(basename $file_and_path)
  echo "Symlinking $FILE for neovim"
  ln -sf $file_and_path "$LUA_DIR/$FILE" | tee -a $LOGFFILE
done

LUA_PLUGIN_CONFIGURATION_DIR="$HOME/.config/nvim/lua/conf"
mkdir -p $LUA_PLUGIN_CONFIGURATION_DIR
LUA_PLUGIN_CONFIGURATION_FILES="$PWD/nvim/lua/conf/*.lua"
for file_and_path in $LUA_PLUGIN_CONFIGURATION_FILES; do
  FILE=$(basename $file_and_path)
  echo "Symlinking $FILE for neovim"
  ln -sf $file_and_path "$LUA_PLUGIN_CONFIGURATION_DIR/$FILE" | tee -a $LOGFFILE
done
# Now symlink to lua modules - once you have written some!

# echo "Copying over vim snippets" | tee -a $LOGFILE
# cp -r "$PWD/vimsnippets" "$HOME/.vim/"

# --------------------------------------------------------------------------------
# Plugins
# --------------------------------------------------------------------------------
echo "Setting up plugins location for neovim" | tee -a $LOGFILE
PLUGIN_DIR="$HOME/.config/nvim/plugin"
mkdir -p $PLUGIN_DIR

# --------------------------------------------------------------------------------
# Plugins
# --------------------------------------------------------------------------------
echo "Setting up file type plugins to configure vim by file types" | tee -a $LOGFILE
FTPLUGIN_DIR="$HOME/.config/nvim/ftplugin"
mkdir -p $FTPLUGIN_DIR
ln -sf "$PWD/nvim/ftplugin/json.vim" "$FTPLUGIN_DIR" | tee -a $LOGFFILE


# --------------------------------------------------------------------------------
# Indent
# --------------------------------------------------------------------------------
echo "Setting up indent location to configure vim indentations" | tee -a $LOGFILE
INDENT_DIR="$HOME/.config/nvim/indent"
mkdir -p $INDENT_DIR



echo "Completed neovim bootstrap" | tee -a $LOGFILE
