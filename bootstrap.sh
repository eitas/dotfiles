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

check_if_app_installed() {
    echo "checking if $1 is installed"
    INSTALL_CHECK=$($1 --version 2> /dev/null)
    if [ -z "$INSTALL_CHECK" ]
    then
      echo "$1 is not installed.. installing.."
      return 0
    else
      echo "$1 is already installed.. skipping.."
      return 1
    fi
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
    if check_if_app_installed brave-browser;
    then 
      sudo apt-get install -y apt-transport-https curl | tee -a $LOGFILE
      sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | tee -a $LOGFILE
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
    fi
 }    

powerline_install() {
    # Powerline
    echo "--------------------" | tee -a $LOGFILE
    echo "installing Powerline" | tee -a $LOGFILE
    echo "--------------------" | tee -a $LOGFILE
    sudo apt-get install powerline -y 2>&1 | tee -a $LOGFILE 
    sudo apt-get install fonts-powerline -y 2>&1 | tee -a $LOGFILE 

    mkdir -p $HOME/.config/powerline
    cp -R /usr/share/powerline/config_files/* $HOME/.config/powerline/
}

apt_install() {
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
    if check_if_app_installed git;
    then 
      sudo apt-get install git -y 2>&1 | tee -a $LOGFILE # you already have git, but just make sure
    fi

    # unzip so I can unzip zip files like terraform
    echo "-----------------------" | tee -a $LOGFILE
    echo "Unzip: unzip zip files!" | tee -a $LOGFILE
    echo "-----------------------" | tee -a $LOGFILE
    sudo apt-get install -y unzip

    # tmux
    echo "------------" | tee -a $LOGFILE
    echo "tmux install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    if check_if_app_installed tmux;
    then 
      sudo apt-get install tmux -y 2>&1 | tee -a $LOGFILE
    fi

    # aws cli
    echo "-----------------" | tee -a $LOGFILE
    echo "aws cli install: " | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    # I need the aws cli v2 so cannot get it from apt
    if check_if_app_installed awscli;
    then 
      #sudo apt-get install awscli -y 2>&1 | tee -a $LOGFILE
      sudo curl -So /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
      sudo unzip -o /tmp/awscliv2.zip -d /tmp
      sudo /tmp/aws/install
      echo "aws version: $( aws --version )" | tee -a $LOGFILE
    fi
   
    # nodejs
    echo "-------------" | tee -a $LOGFILE
    echo "node install: " | tee -a $LOGFILE
    echo "-------------" | tee -a $LOGFILE
    # https://stackoverflow.com/questions/47371904/e-unable-to-locate-package-npm
    # https://tecadmin.net/install-latest-nodejs-npm-on-linux-mint/
    if check_if_app_installed node;
    then 
      sudo apt-get install -y curl software-properties-common 2>&1 | tee -a $LOGFILE
      sudo curl -sL https://deb.nodesource.com/setup_18.x | sudo bash - 2>&1 | tee -a $LOGFILE
      sudo apt-get install -y nodejs 2>&1 | tee -a $LOGFILE
      # checks
      echo "node version: $( node --version )" | tee -a $LOGFILE
      echo "npm version: $( npm --version )" | tee -a $LOGFILE
    fi

    # install the AWS CDK
    echo "----------------" | tee -a $LOGFILE
    echo "aws cdk install: " | tee -a $LOGFILE
    echo "----------------" | tee -a $LOGFILE
    if check_if_app_installed cdk;
    then 
      sudo npm install -g aws-cdk -y 2>&1 | tee -a $LOGFILE
      # checks
      cdk --version | tee -a $LOGFILE
    fi
 
    # TODO AWS SAM

    # tree so I can get nice display of folders and contents
    # within the terminal
    echo "----------------------------------------------" | tee -a $LOGFILE
    echo "Tree: pretty visual of folders in the terminal" | tee -a $LOGFILE
    echo "----------------------------------------------" | tee -a $LOGFILE
    sudo apt-get install -y tree

    # flameshot so I can capture screenshots
    echo "-----------------------------" | tee -a $LOGFILE
    echo "Flameshot: Capture screeshots" | tee -a $LOGFILE
    echo "-----------------------------" | tee -a $LOGFILE
    sudo apt-get install -y flameshot

   
    # cleanup the cache
    sudo apt-get clean -y
    sudo apt-get autoremove -y
}

python_environment_setup() {
    echo "-------------------------------" | tee -a $LOGFILE
    echo "pyenv: multiple python versions" | tee -a $LOGFILE
    echo "-------------------------------" | tee -a $LOGFILE
    if check_if_app_installed pyenv;
    then 
      sudo apt-get install -y make build-essential libssl-dev zlib1g-dev\
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev\
      libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

      git clone https://github.com/pyenv/pyenv.git ~/.pyenv    
    fi

    echo "------------" | tee -a $LOGFILE
    echo "Poetry setup" | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    if check_if_app_installed poetry;
    then
      sudo curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 - 
    fi

    echo "----------------------" | tee -a $LOGFILE
    echo "Black setup for Python" | tee -a $LOGFILE
    echo "----------------------" | tee -a $LOGFILE
    if check_if_app_installed black;
    then
      #Do not install from apt, the version causes issues as there are instability bugs with it
      #when used with vim
      #sudo apt-get install -y black
      pip install black
      sudo apt-get install -y python3-venv
    fi
}

docker_install() {
    # docker
    echo "-----------------" | tee -a $LOGFILE
    echo "installing docker" | tee -a $LOGFILE
    echo "-----------------" | tee -a $LOGFILE
    if check_if_app_installed docker;
    then 
      # allow apt to use a repository over HTTPS
      sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y 2>&1 | tee -a $LOGFILE 
      # add official docker GPG key
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>&1 | tee -a $LOGFILE 
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

      # need to change permissions on some files so that setup to run docker without using sudo works
      sudo chmod 666 /var/run/docker.sock
    fi
}

neovim_install() {
    # Neovim
    # https://github.com/neovim/neovim/wiki/Building-Neovim
    echo "------------" | tee -a $LOGFILE
    echo "neovim install: " | tee -a $LOGFILE
    echo "------------" | tee -a $LOGFILE
    echo "installing from source" | tee -a $LOGFILE
    if check_if_app_installed nvim;
    then 
      # Install the pre-requisites for neovim
      sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
      CWD=$PWD
      cd $PATH_TO_DOTFILES
      rm -rf neovim
      git clone https://github.com/neovim/neovim.git
      git checkout stable
      cd neovim && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/neovim install
      cd $CWD
      # fzf is required for telescope and may not be available by default so install it.
      sudo apt-get install fzf
      # vim-plug to allow me to get neovim plugins working from within init.vim
      sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      # need python3 support for a number of plugins
      sudo apt-get install -y python3-pip
      pip3 install pynvim
      # Need ripgrep for Telescope
      sudo apt-get install -y ripgrep
      # Need fd-find for Telescope
      sudo apt-get install -y fd-find
      mkdir $HOME/.local/bin
      ln -s /usr/bin/fdfind $HOME/.local/bin/fd
      # note to uninstall neovim from source you need the following
      # sudo rm /usr/local/bin/nvim
      # sudo rm -r /usr/local/share/nvim
    fi
}

bootstrap_neovim() {
    echo "------------------------------------" | tee -a $LOGFILE
    echo "Bootstrap Neovim with plugins etc..." | tee -a $LOGFILE
    echo "------------------------------------" | tee -a $LOGFILE
    if check_if_app_installed nvim;
    then 
      $PWD/neovim_bootstrap.sh
    fi
}

slack_install() {
    echo "-------------" | tee -a $LOGFILE
    echo "Slack install" | tee -a $LOGFILE
    echo "-------------" | tee -a $LOGFILE
    #sudo snap install slack --classic
    #snap was disabled in Mint 20, so you need to enable snap
    # (https://itsfoss.com/enable-snap-support-linux-mint/)
    #or you need to do it manually (and officially)
    # https://slack.com/intl/en-gb/downloads/linux
    # There is a small link to the DEB package there
    # this is the best way for now, but it'd be interesting
    # to find a way to do this via the command line.
    #
    # Actually if you go to download the DEB package you cannot get a link
    # But from the destination page you can go to the "Try Again" link:
    # https://downloads.slack-edge.com/releases/linux/4.27.156/prod/x64/slack-desktop-4.27.156-amd64.deb
    # which would download the deb package and then you I am sure can run it
    # though how to maintain the latest version would be tricky so for now
    # leaving this as a manual task
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

language-server-protocol_install() {
    echo "---------------------------------------------" | tee -a $LOGFILE
    echo "Installing relevant language server protocols" | tee -a $LOGFILE
    echo "---------------------------------------------" | tee -a $LOGFILE
    sudo npm i -g vscode-langservers-extracted 
    # Language servers for nvim-lspconfig
    sudo npm i -g pyright
    sudo npm i -g typescript-language-server
    sudo npm i -g bash-language-server

}

set_sudo_default_editor(){
    echo "----------------------------------------------------" | tee -a $LOGFILE
    echo "Setting the default editor to nvim for the root user" | tee -a $LOGFILE
    echo "----------------------------------------------------" | tee -a $LOGFILE
    echo "By default this is normally nano" | tee -a $LOGFILE
    echo "But I want to change it to neovim" | tee -a $LOGFILE
    echo "Neovim is not available as an alternative by default so need to 'install' that" | tee -a $LOGFILE
    # give it a priority of 60 so it is auto selected
    sudo update-alternatives --install "$(which editor)" editor "$(which nvim)" 60 
    # ensure that the update-alternatives for the editor is auto so that it picks the highest priority editor
    # which should be neovim
    sudo update-alternatives --auto editor
    echo "Now performing sudoedit on root owned files should open them in neovim" | tee -a $LOGFILE
}

terraform_install() {
    echo "--------------------" | tee -a $LOGFILE
    echo "Installing Terraform" | tee -a $LOGFILE
    echo "--------------------" | tee -a $LOGFILE
    sudo curl -So /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_amd64.zip | tee -a $LOGFILE
    sudo unzip -o /tmp/terraform.zip -d /usr/local/bin
    
    sudo curl -So /tmp/terraform-ls.zip https://releases.hashicorp.com/terraform-ls/0.29.2/terraform-ls_0.29.2_linux_amd64.zip | tee -a $LOGFILE
    sudo unzip -o /tmp/terraform-ls.zip -d /usr/local/bin
}

remmina_install() {
    echo "--------------------------" | tee -a $LOGFILE
    echo "Installing Remmina for RDP" | tee -a $LOGFILE
    echo "--------------------------" | tee -a $LOGFILE
    sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
    sudo apt update
    sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret
}

home_folder_permissions(){
    echo "Home folder permissions may be set as root, ensure they are set to the user" | tee -a $LOGFILE
    sudo chown -R -v $USER:$USER $HOME
}

final_checklist() {
    echo "---------------------------------------" | tee -a $LOGFILE
    echo "BOOTSTRAPPING COMPLETE: FINAL CHECKLIST" | tee -a $LOGFILE
    echo "---------------------------------------" | tee -a $LOGFILE
    echo "Open new terminal and check Powerline is working." | tee -a $LOGFILE
    echo "Check the symlinks in the home directory point to the dotfiles repo" | tee -a $LOGFILE
    echo "Check Brave Brower is installed." | tee -a $LOGFILE
    echo "Check Chrome is installed, although not used as standard still useful to have around." | tee -a $LOGFILE
    echo "Check git is installed, which it must be to get this far!" | tee -a $LOGFILE
    echo "Check tmux is installed" | tee -a $LOGFILE
    echo "Check aws cli is installed" | tee -a $LOGFILE
    echo "Check node and npm is installed" | tee -a $LOGFILE
    echo "Check aws cdk is installed" | tee -a $LOGFILE
    echo "Check ctags is installed REDUNDANT" | tee -a $LOGFILE
    echo "Check Tree is installed" | tee -a $LOGFILE
    echo "Check pyenv is installed" | tee -a $LOGFILE
    echo "Check Docker is installed" | tee -a $LOGFILE
    echo "Check Neovim has proper plugins setup." | tee -a $LOGFILE
    echo "- Sometimes the setup of vim-plug has not worked and it is ugly, search it on brave" | tee -a $LOGFILE
    echo "Check that sudoedit uses Neovim" | tee -a $LOGFILE
    echo "Check that flameshot has been installed and you can take screenshots" | tee -a $LOGFILE
    echo "Check that Terraform and related terraform-ls has been installed (possibly update the versions)" | tee -a $LOGFILE
    echo "Check that Remmina has been installed so you can RDP onto machines" | tee -a $LOGFILE
}

init
cleanup
link
browser_install
apt_install
powerline_install
python_environment_setup
docker_install
neovim_install
bootstrap_neovim
slack_install
language-server-protocol_install
set_sudo_default_editor
terraform_install
remmina_install
home_folder_permissions
final_checklist
#bootstrap_crontab
END_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Ending eitas dotfile install on $END_TIME" | tee -a $LOGFILE
exit 0

# Troubleshooting
# 06/10/2021 - I had an error where Telescope could not find fzf and this 
# repeated I believe this was because fzf was not available on my Linux Mint 
# 20.2 installation so a sudo apt-get install fzf installed it, but neovim 
# seemed to be stuck without the fzf extension for telescope.  Running
# PlugInstall didn't seem to fix this so I was a bit stuck
# in the end it seems the make for telescope-fzf-native needed to be run again
# so $ cd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
# $ make
# this seemed to fix the issue
