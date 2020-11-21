#!/bin/bash

# inspiration from https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/
# Bootstrap for install on new machines and maintaining structure on existing machines
#
#


# start a log file
NOW=$(date +"%d-%m-%Y_%H_%M_%S")
LOGFILE="dotfile_install_$NOW.log"

START_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Starting eitas dotfile install on $START_TIME" | tee $LOGFILE

# Doing all these installs etc... requires you to be root
# check and exit if not
if ! [ $(id -u) = 0 ]; then
    echo "Failure: Please run the dotfile installs as root" 2>&1 | tee -a $LOGFILE
    exit 1
fi

# setup any required environment variables
source .exports

init() {
    echo "Making github folder in $PATH_TO_DOTFILES if it does not already exist" 2>&1 | tee -a $LOGFILE
    mkdir -p "$PATH_TO_DOTFILES"
}

link() {    
    dotfile_list="$PWD/dotfile_list.config"
    while IFS= read -r dotfile_name
    do
      echo "adding / updating symlink for $dotfile_name" 2>&1 | tee -a $LOGFILE
      ln -sf "$PWD/$dotfile_name" "$HOME"
    done < "$dotfile_list"
    echo "-----------"
#    for file in $(basename $PATH_TO_DOTFILES/.{bashrc,exports,extra,functions,bash_prompt,aliases,vimrc,tmux.conf};) do
#      # silently ignore errors as the files may already exist
#      echo "adding symlink for $file" 2>&1 | tee -a $LOGFILE
#      echo "ln -sf $PWD/$(basename $file) $HOME"
#      ln -sv "$PWD/$file" "$HOME" || true
#    done
#    unset file
}

apt_installs() {
    # I am only working within a Linux debian based environment so will run installs from here
    echo "------------------------" | tee -a $LOGFILE
    echo "updating package manager" | tee -a $LOGFILE
    echo "------------------------" | tee -a $LOGFILE
    apt update -y
    echo "------------------" | tee -a $LOGFILE
    echo "upgrading packages" | tee -a $LOGFILE
    echo "------------------" | tee -a $LOGFILE
    apt update -y
    echo "------------------------" | tee -a $LOGFILE
    echo "package updates complete" | tee -a $LOGFILE
    echo "------------------------" | tee -a $LOGFILE

    # git
    echo "--------------" | tee -a $LOGFILE
    echo "installing git" | tee -a $LOGFILE
    echo "--------------" | tee -a $LOGFILE
    apt install git -y # answer yes to all prompts

    # docker
    echo "-----------------" | tee -a $LOGFILE
    echo "installing docker" | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    # allow apt to use a repository over HTTPS
    apt install apt-transport-https ca-certificates curl software-properties-common -y
    # add official docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    # install the stable docker repository
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # refresh the apt cache
    apt update -y
    # install
    apt install docker-ce docker-ce-cli containerd.io -y
    echo "Verifying docker installation using a hello world container..."   
    docker run hello-world

    # Docker Compose
    apt install docker-compose -y

    # Vim
    echo "------------" | tee -a $LOGFILE
    echo "vim install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    apt install vim -y
    # checks
    vim --version 2>&1 | tee -a $LOGFILE

    # tmux
    echo "------------" | tee -a $LOGFILE
    echo "tmux install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    apt install tmux -y

    # aws cli
    echo "-----------------" | tee -a $LOGFILE
    echo "aws cli install: " | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    # this assumes a python3 installation
    # need to keep an eye on this and perhaps
    # put some defensive code in.
    pip3 install awscli
    aws --version | tee -a $LOGFILE
 
    # nodejs
    echo "-------------" | tee -a $LOGFILE
    echo "node install: " | tee -a $LOGFILE
    echo "-------------" | tee -a $LOGFILE
    # https://stackoverflow.com/questions/47371904/e-unable-to-locate-package-npm
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt install -y nodejs
    # checks
    node --version | tee -a $LOGFILE

    # npm
    echo "-------------" | tee -a $LOGFILE
    echo "npm install: " | tee -a $LOGFILE
    echo "-------------" | tee -a $LOGFILE
    apt install npm -y
    # checks
    npm --version | tee -a $LOGFILE

    # install the AWS CDK
    echo "----------------" | tee -a $LOGFILE
    echo "aws cdk install: " | tee -a $LOGFILE
    echo "----------------" | tee -a $LOGFILE
    npm install -g aws-cdk -y
    # checks
    cdk --version | tee -a $LOGFILE
 

    # TODO AWS SAM

    
    # cleanup the cache
    apt clean
    apt autoremove
}

bootstrap_vim() {
    # TODO
    echo "Bootstrap Vim with plugins etc..." | tee -a $LOGFILE
}

bootstrap_crontab() {
    # TODO
    echo "Setting up crontabs" | tee -a $LOGFILE
    # this does nothing at present but the 
    # thought of using a crontab to automatically
    # push dotfiles changes to master is useful
    # though I need to adjust the script and consider the 
    # commits, webhooks checks etc...
    # see here for the example
    # https://github.com/ajmalsiddiqui/dotfiles/blob/master/crontab.bootstrap.exclude.sh
}

# init
link
# apt_installs
bootstrap_vim
bootstrap_crontab
END_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Ending eitas dotfile install on $END_TIME" | tee -a $LOGFILE
exit 0

