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

# ------------------------------------------------------------------------------
# The below is now superceded by powerline, but useful to keep around
# ------------------------------------------------------------------------------

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

# ------------------------------------------------------------------------------
# The above is now superceded by powerline, but useful to keep around
# ------------------------------------------------------------------------------

# https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
# Ctrl-S hangs vim and I want to be able to use that for saving files so switch
# it off
# 2021-10-03 This is causing an error on boot so should investigate this 
# again and determine its requirements
#bind -r '\C-s'
#stty -ixon

# change the capslock key behaviour in Ubuntu
xmodmap -e "keycode 66 = Shift_L"

# Setup Powerline
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/share/powerline/bindings/bash/powerline.sh
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

# ------------------------------------------------------------------------------
# tmux.  I always want to run in tmux now, so lets start a tmux session
# when starting a terminal shell.  Thanks to thoughtbot for the input
# https://thoughtbot.com/upcase/videos/tmux-advanced-workflow
# ------------------------------------------------------------------------------
not_inside_tmux() { 
  [ -z "$TMUX" ] 
}

check_home_tmux() {
  if ! tmux has-session -t "home" 2> /dev/null; then
    echo "home is not running"
  else
    echo "home is running"
  fi
}

ensure_tmux_is_running() {
  if not_inside_tmux; then
    if tmux has-session -t "home"; then
      echo "tmux has a session home running"
      mytmux
    else
      mytmux "home"
      exit 0
    fi
  fi 
}

# ensure_tmux_is_running

complete -C /usr/local/bin/terraform terraform

complete -C /home/max/github/dotfiles/.tfenv/versions/1.2.8/terraform terraform
