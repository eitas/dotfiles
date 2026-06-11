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
# ln -sf "$PWD/nvim/init.vim" "$NVIM_DIR/init.vim" | tee -a $LOGFILE
ln -sf "$PWD/nvim/init.lua" "$NVIM_DIR/init.lua" | tee -a $LOGFILE

# --------------------------------------------------------------------------------
# configure python environment to support Neovim plugins
# --------------------------------------------------------------------------------
NVIM_VENV="$HOME/.config/nvim/venv"
if [ ! -d "$NVIM_VENV" ]; then
  python3 -m venv "$NVIM_VENV"
fi

# activate venv and install pynvim
source "$NVIM_VENV/bin/activate"
pip install --upgrade pip pynvim 2>&1 | tee -a $LOGFILE
deactivate

# update remote plugins
nvim --headless +UpdateRemotePlugins +qa 2>&1 | tee -a $LOGFILE

echo "Neovim Python provider set up at $NVIM_VENV"

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
  ln -sf $file_and_path "$LUA_DIR/$FILE" | tee -a $LOGFILE
done

# --------------------------------------------------------------------------------
# I want to be able to copy local plugin development to the XDG_CONFIG_HOME
# So it loads automatically with vim
# --------------------------------------------------------------------------------
LOCAL_PLUGIN_CONFIGURATION_DIR="$HOME/.config/nvim/plugin"
mkdir -p $LOCAL_PLUGIN_CONFIGURATION_DIR
LOCAL_PLUGINS=($PWD/../*nvim)
if [ -e "${LOCAL_PLUGINS[0]}" ]; then
  for plugin in "${LOCAL_PLUGINS[@]}"; do
    echo "Copying $plugin to $LOCAL_PLUGIN_CONFIGURATION_DIR" | tee -a $LOGFILE
    rsync -a "$plugin" "$LOCAL_PLUGIN_CONFIGURATION_DIR" --exclude .git --exclude .gitignore 2>&1 | tee -a $LOGFILE
  done
else
  echo "No local *nvim plugin directories found in $PWD/.. — skipping" | tee -a $LOGFILE
fi

# --------------------------------------------------------------------------------
# Once we have our plugins we want to also have specific conf files which
# setup the plugins for my specific setup
# --------------------------------------------------------------------------------
LUA_PLUGIN_CONFIGURATION_DIR="$HOME/.config/nvim/lua/conf"
mkdir -p $LUA_PLUGIN_CONFIGURATION_DIR
LUA_PLUGIN_CONFIGURATION_FILES="$PWD/nvim/lua/conf/*.lua"
for file_and_path in $LUA_PLUGIN_CONFIGURATION_FILES; do
  FILE=$(basename $file_and_path)
  echo "Symlinking $FILE for neovim"
  ln -sf $file_and_path "$LUA_PLUGIN_CONFIGURATION_DIR/$FILE" | tee -a $LOGFILE
done
# Now symlink to lua modules - once you have written some!

# echo "Copying over vim snippets" | tee -a $LOGFILE
# cp -r "$PWD/vimsnippets" "$HOME/.vim/"

# --------------------------------------------------------------------------------
# Indent
# --------------------------------------------------------------------------------
echo "Setting up indent location to configure vim indentations" | tee -a $LOGFILE
INDENT_DIR="$HOME/.config/nvim/indent"
mkdir -p $INDENT_DIR



# --------------------------------------------------------------------------------
# VSCode Neovim integration
# --------------------------------------------------------------------------------
echo "Setting up VSCode Neovim integration" | tee -a $LOGFILE
VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
mkdir -p "$VSCODE_SETTINGS_DIR"
if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
  echo "VSCode settings.json already exists — merging neovim settings" | tee -a $LOGFILE
  # Use a temp file to merge; only add keys that don't already exist
  python3 -c "
import json, sys
target = '$VSCODE_SETTINGS_DIR/settings.json'
source = '$PWD/vscode/settings.json'
with open(target) as f: t = json.load(f)
with open(source) as f: s = json.load(f)
for k,v in s.items():
    t.setdefault(k, v)
with open(target, 'w') as f: json.dump(t, f, indent=2)
" 2>&1 | tee -a $LOGFILE
else
  cp "$PWD/vscode/settings.json" "$VSCODE_SETTINGS_DIR/settings.json"
fi

echo "Completed neovim bootstrap" | tee -a $LOGFILE
