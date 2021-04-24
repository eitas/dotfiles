#!/bin/bash
# Taken from Paul Irish dotfiles on github!
#
# Also referenced:
#  http://news.softpedia.com/news/How-to-Customize-the-Shell-Prompt-40033.shtml
#  http://scottlab.ucsc.edu//xtal/iterm_tab_customization.html

# load separate dotfiles, which is a good idea from Paul Irish
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
  source "$file"
done
unset file

default_username='max'

# Setup to use full set of colours
# Note /dev/null is a black hole bucket where we redirect standard output
# we then (2>&1) redirect errors to the screen
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM=xterm-256color
fi

# Setup terminal colours.  If this gets confusing check this out: http://www.cplusplus.com/forum/unices/36461/

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 190)
		PURPLE=$(tput setaf 141)
		WHITE=$(tput setaf 256)
	else
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
		GREEN=$(tput setaf 2)
		PURPLE=$(tput setaf 1)
		WHITE=$(tput setaf 7)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	WHITE="\033[1;37m"
	BOLD=""
	RESET="\033[m"
fi

# Now setup the prompt.  The text used for the prompt is held in the environment variable PS1
PS1="\[\e]2;$PWD\[\a\]\[\e]1;\]$(basename "$(dirname "$PWD")")/\W\[\a\]${BOLD}\$(usernamehost)\[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"

# https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
# Ctrl-S hangs vim and I want to be able to use that for saving files so switch
# it off
bind -r '\C-s'
stty -ixon

# Set language and use UTF-8
export LC_ALL=en_GB.UTF-8
# Set path to include mySQL
export PATH=/usr/local/bin:/usr/local/mysql/bin:$PATH
# Set path to include Poetry
export PATH=$HOME/.poetry/bin:$PATH
# setup vim as the default editor in my terminals
export VISUAL=vim
export EDITOR="$VISUAL"

export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"
