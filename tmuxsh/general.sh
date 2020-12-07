#!/bin/bash

# General Tmux session setup.  This script can be adapted for specific environments

SESSION_NAME=general
FIRST_WINDOW_NAME=editing
STARTING_PWD=~/Documents/03_Home/01_Code

tmux has-session -t $SESSION_NAME &> /dev/null

# If there is no existing session then set it up
if [ $? != 0 ]
then 
	tmux new-session -s $SESSION_NAME -n $FIRST_WINDOW_NAME -d
	# C-m - Carriage Return
	tmux send-keys -t $SESSION_NAME "cd $STARTING_PWD" C-m
	# Start up vim in our single window tmux environment
	tmux send-keys -t $SESSION_NAME 'vim' C-m
	# split the window so the vim window is above and a terminal window below
	tmux split-window -v -p 10 -t $SESSION_NAME 
	# targetting the bottom pane of the window (i.e. the terminal) via SESSION_NAME:Window.Pane
	# change to the project directory
	tmux send-keys -t $SESSION_NAME:1.2 "cd $STARTING_PWD" c-m
fi

tmux attach -t $SESSION_NAME

