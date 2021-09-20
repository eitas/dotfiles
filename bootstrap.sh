#!/bin/bash

# inspiration from https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/
# Bootstrap for install on new machines and maintaining structure on existing machines
#
#


# start a log file
NOW=$(date +"%d-%m-%Y_%H_%M_%S")
# Make a logs directory whereever you are executing this from 
mkdir -p ./logs
LOGFILE="./logs/dotfile_install_$NOW.log"
# export the log file so it can be used in subsequent scripts
export LOGFILE

START_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Starting eitas dotfile install on $START_TIME" | tee $LOGFILE

# Doing all these installs etc... requires you to be root
# check and exit if not
#if ! [ $(id -u) = 0 ]; then
#    echo "Failure: Please run the dotfile installs as root" 2>&1 | tee -a $LOGFILE
#    echo "Please also preserve the home directory of the user so the symlinks to dotfiles are accurate \$sudo --preserve-env=HOME ./bootstrap.sh" 2>&1 | tee -a $LOGFILE
#    exit 1
#fi

# setup any required environment variables including PATH_TO_DOTFILES
source .exports

init() {
    echo "Making github folder in $PATH_TO_DOTFILES if it does not already exist" 2>&1 | tee -a $LOGFILE
    mkdir -p "$PATH_TO_DOTFILES"
}

cleanup() {
    # cleanup the cache
    echo "-------" | tee -a $LOGFILE
    echo "Cleaning up package manager and redundant packages" | tee -a $LOGFILE
    echo "-------" | tee -a $LOGFILE
    sudo apt-get clean -y
    sudo apt-get autoremove -y
}


link() {    
    dotfile_list="$PWD/dotfile_list.config"
    while IFS= read -r dotfile_name
    do
      echo "adding / updating symlink for $dotfile_name" 2>&1 | tee -a $LOGFILE
      ln -sf "$PWD/$dotfile_name" "$HOME" | tee -a $LOGFFILE
    done < "$dotfile_list"
    echo "-----------"
}

browser_install() {
    echo "----------------------------" | tee -a $LOGFILE
    echo "installing the Brave browser" | tee -a $LOGFILE
    echo "----------------------------" | tee -a $LOGFILE
    sudo apt-get install -y apt-transport-https curl | tee -a $LOGFILE # I doubt curl won't be there, but just make sure
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | tee -a $LOGFILE
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt-get update
    sudo apt-get install -y brave-browser

    # chrome
    echo "-----------------" | tee -a $LOGFILE
    echo "installing chrome" | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list 
    sudo apt-get update -y
    sudo apt-get install -y google-chrome-stable
 }    

apt_installs() {
    # I am only working within a Linux debian based environment so will run installs from here
    echo "------------------------" | tee -a $LOGFILE
    echo "updating package manager" | tee -a $LOGFILE
    echo "------------------------" | tee -a $LOGFILE
    sudo apt-get update -y
    echo "------------------------" | tee -a $LOGFILE
    echo "package updates complete" | tee -a $LOGFILE
    echo "------------------------" | tee -a $LOGFILE


   
    # git
    echo "--------------" | tee -a $LOGFILE
    echo "installing git" | tee -a $LOGFILE
    echo "--------------" | tee -a $LOGFILE
    sudo apt-get install git -y 2>&1 | tee -a $LOGFILE # you already have git, but just make sure


    # tmux
    echo "------------" | tee -a $LOGFILE
    echo "tmux install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    sudo apt-get install tmux -y 2>&1 | tee -a $LOGFILE

    # aws cli
    echo "-----------------" | tee -a $LOGFILE
    echo "aws cli install: " | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    # this assumes a python3 installation
    # need to keep an eye on this and perhaps
    # put some defensive code in.
    sudo apt-get install awscli -y 2>&1 | tee -a $LOGFILE
    echo "aws version: $( aws --version )" | tee -a $LOGFILE
 
    # nodejs
    echo "-------------" | tee -a $LOGFILE
    echo "node install: " | tee -a $LOGFILE
    echo "-------------" | tee -a $LOGFILE
    # https://stackoverflow.com/questions/47371904/e-unable-to-locate-package-npm
    # https://tecadmin.net/install-latest-nodejs-npm-on-linux-mint/
    sudo apt-get install -y curl python-software-properties software-properties-common 2>&1 | tee -a $LOGFILE
    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash - 2>&1 | tee -a $LOGFILE
    sudo apt-get install -y nodejs 2>&1 | tee -a $LOGFILE
    # checks
    echo "node version: $( node --version )" | tee -a $LOGFILE
    echo "npm version: $( npm --version )" | tee -a $LOGFILE

    # npm
#    echo "-------------" | tee -a $LOGFILE
#    echo "npm install: " | tee -a $LOGFILE
#    echo "-------------" | tee -a $LOGFILE
#    apt install npm -y
#    # checks
#    npm --version | tee -a $LOGFILE
#
    # install the AWS CDK
    echo "----------------" | tee -a $LOGFILE
    echo "aws cdk install: " | tee -a $LOGFILE
    echo "----------------" | tee -a $LOGFILE
    sudo npm install -g aws-cdk -y 2>&1 | tee -a $LOGFILE
    # checks
    cdk --version | tee -a $LOGFILE
 
    echo "-------" | tee -a $LOGFILE
    echo "ctags: " | tee -a $LOGFILE
    echo "-------" | tee -a $LOGFILE
    sudo apt-get install -y exuberant-ctags 2>&1 | tee -a $LOGFILE


    # TODO AWS SAM

    
    # cleanup the cache
    sudo apt-get clean -y
    sudo apt-get autoremove -y
}

docker_install() {
    # docker
    echo "-----------------" | tee -a $LOGFILE
    echo "installing docker" | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    # allow apt to use a repository over HTTPS
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y 2>&1 | tee -a $LOGFILE 
    # add official docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>&1 | tee -a $LOGFILE 
    # install the stable docker repository
    #add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # Note above doesn't work on Mint Tina, so hard-coding bionic in there
    add-apt-repository deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
    # refresh the apt cache
    sudo apt-get update -y
    # install
    sudo apt-get install -y docker.io
    echo "Verifying docker installation using a hello world container..."   
    docker run hello-world

    # Docker Compose
    sudo apt-get install docker-compose -y
}

neovim_install() {
    # Neovim
    # https://github.com/neovim/neovim/wiki/Building-Neovim
    echo "------------" | tee -a $LOGFILE
    echo "neovim install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    echo "installing from source" | tee -a $LOGFILE
    # Install the pre-requisites
    sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
    CWD=$PWD
    cd $PATH_TO_DOTFILES
    rm -rf neovim
    git clone https://github.com/neovim/neovim.git
    git checkout stable
    cd neovim && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/neovim install
    cd $CWD
    # note to uninstall from source:
    # sudo rm /usr/local/bin/nvim
    # sudo rm -r /usr/local/share/nvim
}

bootstrap_neovim() {
    echo "-------" | tee -a $LOGFILE
    echo "Bootstrap Neovim with plugins etc..." | tee -a $LOGFILE
    echo "-------" | tee -a $LOGFILE
    $PWD/nvim_bootstrap.sh
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


init
cleanup
link
browser_install
apt_installs
docker_install
neovim_install
#bootstrap_neovim
#bootstrap_crontab
END_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Ending eitas dotfile install on $END_TIME" | tee -a $LOGFILE
exit 0

