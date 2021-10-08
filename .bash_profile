# Through the use of Tmux and the desire to manipulate a
# session when creating or attaching to it I need to manage the distinction
# between a login shell and a non-login shell.
#
# I was having some issues with the $WORK_HOME exports that are
# creating when sourcing the bashrc, so I will create
# a reference to ensure that environment variables
# on starting tmux are setup as per bashrc
source $HOME/.bashrc
