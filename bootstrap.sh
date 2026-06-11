#!/bin/bash
set -uo pipefail

# Bootstrap for install on new machines and maintaining structure on existing machines
# inspiration from https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/

MYHOSTNAME="max-thomas"

# start a log file
NOW=$(date +"%d-%m-%Y_%H_%M_%S")
mkdir -p ./logs
LOGFILE="./logs/dotfile_install_$NOW.log"
export LOGFILE
START_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Starting eitas dotfile install on $START_TIME" | tee "$LOGFILE"

source .exports

init() {
    echo "Making github folder in $PATH_TO_DOTFILES if it does not already exist" 2>&1 | tee -a "$LOGFILE"
    mkdir -p "$PATH_TO_DOTFILES"
}

sethostname() {
  echo "Setting hostname to $MYHOSTNAME" 2>&1 | tee -a "$LOGFILE"
  hostnamectl set-hostname "$MYHOSTNAME"
}

# Returns 0 (true) if the command is found in PATH, 1 (false) if not.
# Usage: if is_installed git; then ... (skip) ... else ... (install) ...
# Or:    if ! is_installed git; then ... (install) ...
is_installed() {
    local cmd=$1
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd is already installed — skipping" | tee -a "$LOGFILE"
        return 0
    else
        echo "$cmd is not installed — installing" | tee -a "$LOGFILE"
        return 1
    fi
}

cleanup() {
    echo "-------" | tee -a "$LOGFILE"
    echo "Cleaning up package manager and redundant packages" | tee -a "$LOGFILE"
    echo "-------" | tee -a "$LOGFILE"
    sudo apt-get clean -y
    sudo apt-get autoremove -y
}

link() {
    dotfile_list="$PWD/dotfile_list.config"
    while IFS= read -r dotfile_name
    do
      echo "adding / updating symlink for $dotfile_name" 2>&1 | tee -a "$LOGFILE"
      ln -sf "$PWD/$dotfile_name" "$HOME" | tee -a "$LOGFILE"
    done < "$dotfile_list"
    echo "-----------"
}

browser_install() {
    echo "----------------------------" | tee -a "$LOGFILE"
    echo "installing the Brave browser" | tee -a "$LOGFILE"
    echo "----------------------------" | tee -a "$LOGFILE"
    if ! is_installed brave-browser; then
      sudo apt-get install -y apt-transport-https curl | tee -a "$LOGFILE"
      sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | tee -a "$LOGFILE"
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
      sudo apt-get update
      sudo apt-get install -y brave-browser

      echo "-----------------" | tee -a "$LOGFILE"
      echo "installing chrome" | tee -a "$LOGFILE"
      echo "-----------------" | tee -a "$LOGFILE"
      wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/google-chrome.gpg >/dev/null
      echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
      sudo apt-get update -y
      sudo apt-get install -y google-chrome-stable
    fi
}

powerline_install() {
    echo "--------------------" | tee -a "$LOGFILE"
    echo "installing Powerline" | tee -a "$LOGFILE"
    echo "--------------------" | tee -a "$LOGFILE"
    sudo apt-get install powerline -y 2>&1 | tee -a "$LOGFILE"
    sudo apt-get install fonts-powerline -y 2>&1 | tee -a "$LOGFILE"

    mkdir -p "$HOME/.config/powerline"
    cp -R /usr/share/powerline/config_files/* "$HOME/.config/powerline/"
}

ssh_configuration() {
    echo "--------------------" | tee -a "$LOGFILE"
    echo "configuring ssh" | tee -a "$LOGFILE"
    echo "--------------------" | tee -a "$LOGFILE"
    mkdir -p "$HOME/.ssh"
    cp -R .sshconfig "$HOME/.ssh/config"
}

apt_install() {
    echo "------------------------" | tee -a "$LOGFILE"
    echo "updating package manager" | tee -a "$LOGFILE"
    echo "------------------------" | tee -a "$LOGFILE"
    sudo apt-get update -y
    echo "------------------------" | tee -a "$LOGFILE"
    echo "package updates complete" | tee -a "$LOGFILE"
    echo "------------------------" | tee -a "$LOGFILE"

    echo "--------------" | tee -a "$LOGFILE"
    echo "installing git" | tee -a "$LOGFILE"
    echo "--------------" | tee -a "$LOGFILE"
    if ! is_installed git; then
      sudo apt-get install git -y 2>&1 | tee -a "$LOGFILE"
    fi

    echo "-----------------------" | tee -a "$LOGFILE"
    echo "Unzip: unzip zip files!" | tee -a "$LOGFILE"
    echo "-----------------------" | tee -a "$LOGFILE"
    sudo apt-get install -y unzip

    echo "------------" | tee -a "$LOGFILE"
    echo "tmux install:" | tee -a "$LOGFILE"
    echo "------------" | tee -a "$LOGFILE"
    if ! is_installed tmux; then
      sudo apt-get install tmux -y 2>&1 | tee -a "$LOGFILE"
    fi

    echo "-----------------" | tee -a "$LOGFILE"
    echo "aws cli install:" | tee -a "$LOGFILE"
    echo "-----------------" | tee -a "$LOGFILE"
    if ! is_installed aws; then
      sudo curl -So /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
      sudo unzip -o /tmp/awscliv2.zip -d /tmp
      sudo /tmp/aws/install
      sudo rm -rf /tmp/aws /tmp/awscliv2.zip
      echo "aws version: $(aws --version)" | tee -a "$LOGFILE"
    fi

    echo "-----------------" | tee -a "$LOGFILE"
    echo "aws SAM cli install:" | tee -a "$LOGFILE"
    echo "-----------------" | tee -a "$LOGFILE"
    if ! is_installed sam; then
      sudo curl -So /tmp/awssamcli.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
      sudo unzip -o /tmp/awssamcli.zip -d /tmp/aws-sam
      sudo /tmp/aws-sam/install
      sudo rm -rf /tmp/aws-sam /tmp/awssamcli.zip
      echo "aws sam version: $(sam --version)" | tee -a "$LOGFILE"
    fi

    echo "-------------" | tee -a "$LOGFILE"
    echo "node install:" | tee -a "$LOGFILE"
    echo "-------------" | tee -a "$LOGFILE"
    NODE_REQUIRED=22
    NODE_CURRENT=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1 || echo "0")
    if [ -z "$NODE_CURRENT" ] || [ "$NODE_CURRENT" -lt "$NODE_REQUIRED" ]; then
      echo "Node not installed or version $NODE_CURRENT < $NODE_REQUIRED — installing Node $NODE_REQUIRED" | tee -a "$LOGFILE"
      sudo apt-get install -y curl software-properties-common 2>&1 | tee -a "$LOGFILE"
      curl -fsSL https://deb.nodesource.com/setup_${NODE_REQUIRED}.x | sudo -E bash - 2>&1 | tee -a "$LOGFILE"
      sudo apt-get install -y nodejs 2>&1 | tee -a "$LOGFILE"
    else
      echo "Node v$NODE_CURRENT already meets minimum v$NODE_REQUIRED — skipping" | tee -a "$LOGFILE"
    fi
    echo "node version: $(node --version)" | tee -a "$LOGFILE"
    echo "npm version: $(npm --version)" | tee -a "$LOGFILE"

    echo "----------------" | tee -a "$LOGFILE"
    echo "aws cdk install:" | tee -a "$LOGFILE"
    echo "----------------" | tee -a "$LOGFILE"
    if ! is_installed cdk; then
      sudo npm install -g aws-cdk 2>&1 | tee -a "$LOGFILE"
      cdk --version | tee -a "$LOGFILE"
    fi

    echo "----------------------------------------------" | tee -a "$LOGFILE"
    echo "Tree: pretty visual of folders in the terminal" | tee -a "$LOGFILE"
    echo "----------------------------------------------" | tee -a "$LOGFILE"
    sudo apt-get install -y tree

    echo "-------------------------------------------------" | tee -a "$LOGFILE"
    echo "Flameshot: Capture screenshots, apply blur etc..." | tee -a "$LOGFILE"
    echo "-------------------------------------------------" | tee -a "$LOGFILE"
    sudo apt-get install -y flameshot

    echo "----------------" | tee -a "$LOGFILE"
    echo "Luarocks install:" | tee -a "$LOGFILE"
    echo "----------------" | tee -a "$LOGFILE"
    if ! is_installed luarocks; then
      sudo apt-get install -y luarocks 2>&1 | tee -a "$LOGFILE"
      sudo luarocks install luasocket 2>&1 | tee -a "$LOGFILE"
      sudo luarocks install luasec 2>&1 | tee -a "$LOGFILE"
      sudo luarocks install dkjson 2>&1 | tee -a "$LOGFILE"
      luarocks --version | tee -a "$LOGFILE"
    fi

    sudo apt-get clean -y
    sudo apt-get autoremove -y
}

python_environment_setup() {
    echo "-------------------------------" | tee -a "$LOGFILE"
    echo "pyenv: multiple python versions" | tee -a "$LOGFILE"
    echo "-------------------------------" | tee -a "$LOGFILE"
    if ! is_installed pyenv; then
      sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
        libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
      git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    fi

    echo "------------" | tee -a "$LOGFILE"
    echo "Poetry setup" | tee -a "$LOGFILE"
    echo "------------" | tee -a "$LOGFILE"
    if ! is_installed poetry; then
      curl -sSL https://install.python-poetry.org | python3 -
    fi

    echo "----------------------" | tee -a "$LOGFILE"
    echo "Black setup for Python" | tee -a "$LOGFILE"
    echo "----------------------" | tee -a "$LOGFILE"
    if ! is_installed black; then
      pip install black
      sudo apt-get install -y python3-venv
    fi
}

docker_install() {
    echo "-----------------" | tee -a "$LOGFILE"
    echo "installing docker" | tee -a "$LOGFILE"
    echo "-----------------" | tee -a "$LOGFILE"
    if ! is_installed docker; then
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common 2>&1 | tee -a "$LOGFILE"
      # Use modern keyring approach (apt-key is deprecated since Ubuntu 22.04)
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
      sudo apt-get update -y
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      echo "Verifying docker installation using a hello world container..."
      sudo docker run hello-world

      # Add user to docker group instead of chmod 666 on the socket (which is a security risk)
      sudo usermod -aG docker "$USER"
      echo "NOTE: Log out and back in (or run 'newgrp docker') for docker group membership to take effect" | tee -a "$LOGFILE"
    fi
}

neovim_install() {
    echo "------------" | tee -a "$LOGFILE"
    echo "neovim install:" | tee -a "$LOGFILE"
    echo "------------" | tee -a "$LOGFILE"
    if ! is_installed nvim; then
      echo "installing from source" | tee -a "$LOGFILE"
      sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
      CWD=$PWD
      cd "$PATH_TO_DOTFILES"
      rm -rf neovim
      git clone https://github.com/neovim/neovim.git
      cd neovim
      git checkout stable
      make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/neovim" install
      cd "$CWD"
      # fzf required for telescope
      sudo apt-get install -y fzf
      # need python3 support for a number of plugins
      sudo apt-get install -y python3-pip
      pip3 install pynvim
      # ripgrep and fd-find required for Telescope
      sudo apt-get install -y ripgrep
      sudo apt-get install -y fd-find
      mkdir -p "$HOME/.local/bin"
      ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"
      # note to uninstall neovim from source:
      # sudo rm /usr/local/bin/nvim
      # sudo rm -r /usr/local/share/nvim
    fi
}

bootstrap_neovim() {
    echo "------------------------------------" | tee -a "$LOGFILE"
    echo "Bootstrap Neovim with plugins etc..." | tee -a "$LOGFILE"
    echo "------------------------------------" | tee -a "$LOGFILE"
    "$PWD/neovim_bootstrap.sh"
}

slack_install() {
    echo "-------------" | tee -a "$LOGFILE"
    echo "Slack install" | tee -a "$LOGFILE"
    echo "-------------" | tee -a "$LOGFILE"
    # Slack has no apt repository; download the .deb manually from https://slack.com/downloads/linux
}

lsp_install() {
    echo "---------------------------------------------" | tee -a "$LOGFILE"
    echo "Installing relevant language server protocols" | tee -a "$LOGFILE"
    echo "---------------------------------------------" | tee -a "$LOGFILE"
    # Note: pyright, bashls, and terraformls are managed by Mason inside Neovim (:Mason)
    sudo npm i -g vscode-langservers-extracted
    sudo npm i -g typescript-language-server
}

set_sudo_default_editor() {
    echo "----------------------------------------------------" | tee -a "$LOGFILE"
    echo "Setting the default editor to nvim for the root user" | tee -a "$LOGFILE"
    echo "----------------------------------------------------" | tee -a "$LOGFILE"
    # give it a priority of 60 so it is auto selected
    sudo update-alternatives --install "$(which editor)" editor "$(which nvim)" 60
    sudo update-alternatives --auto editor
    echo "Now performing sudoedit on root owned files should open them in neovim" | tee -a "$LOGFILE"
}

terraform_install() {
    echo "--------------------" | tee -a "$LOGFILE"
    echo "Installing Terraform" | tee -a "$LOGFILE"
    echo "--------------------" | tee -a "$LOGFILE"
    # Use tfenv (already in this repo as a submodule) rather than a hardcoded version zip
    if ! is_installed terraform; then
      tfenv install latest | tee -a "$LOGFILE"
      tfenv use latest | tee -a "$LOGFILE"
    fi
    terraform --version | tee -a "$LOGFILE"
    # terraform-ls is now managed by Mason inside Neovim (:Mason)
}

plantuml_install() {
    echo "-------------------------" | tee -a $LOGFILE
    echo "installing PlantUML (local)" | tee -a $LOGFILE
    echo "-------------------------" | tee -a $LOGFILE
    mkdir -p $HOME/tools
    if [ ! -f "$HOME/tools/plantuml.jar" ]; then
      curl -sSL -o "$HOME/tools/plantuml.jar" https://github.com/plantuml/plantuml/releases/download/v1.2025.2/plantuml-1.2025.2.jar
      echo "PlantUML jar downloaded" | tee -a $LOGFILE
    else
      echo "PlantUML jar already exists — skipping" | tee -a $LOGFILE
    fi
    if [ ! -d "$HOME/tools/C4-PlantUML" ]; then
      git clone --depth 1 https://github.com/plantuml-stdlib/C4-PlantUML.git "$HOME/tools/C4-PlantUML" 2>&1 | tee -a $LOGFILE
    else
      echo "C4-PlantUML already exists — skipping" | tee -a $LOGFILE
    fi
}

vscode_install() {
    echo "-------------------" | tee -a "$LOGFILE"
    echo "installing VS Code" | tee -a "$LOGFILE"
    echo "-------------------" | tee -a "$LOGFILE"
    if ! is_installed code; then
      sudo apt-get install -y wget gpg apt-transport-https | tee -a "$LOGFILE"
      wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
      sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
      echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
      rm -f /tmp/packages.microsoft.gpg
      sudo apt-get update -y
      sudo apt-get install -y code | tee -a "$LOGFILE"
    fi
    # Install the Neovim extension (idempotent — skips if already installed)
    code --install-extension asvetliakov.vscode-neovim 2>&1 | tee -a "$LOGFILE"
}

remmina_install() {
    echo "--------------------------" | tee -a "$LOGFILE"
    echo "Installing Remmina for RDP" | tee -a "$LOGFILE"
    echo "--------------------------" | tee -a "$LOGFILE"
    sudo apt-add-repository --yes ppa:remmina-ppa-team/remmina-next
    sudo apt update
    sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret
}

home_folder_permissions() {
    echo "Home folder permissions may be set as root, ensure they are set to the user" | tee -a "$LOGFILE"
    sudo chown -R -v "$USER:$USER" "$HOME"
}

bootstrap_crontab() {
    # TODO: auto-push dotfile changes to master
    echo "Setting up crontabs" | tee -a "$LOGFILE"
}

final_checklist() {
    echo "---------------------------------------" | tee -a "$LOGFILE"
    echo "BOOTSTRAPPING COMPLETE: FINAL CHECKLIST" | tee -a "$LOGFILE"
    echo "---------------------------------------" | tee -a "$LOGFILE"
    echo "Open new terminal and check Powerline is working." | tee -a "$LOGFILE"
    echo "Check the symlinks in the home directory point to the dotfiles repo" | tee -a "$LOGFILE"
    echo "Check Brave Browser is installed (brave-browser --version)" | tee -a "$LOGFILE"
    echo "Check Chrome is installed (google-chrome --version)" | tee -a "$LOGFILE"
    echo "Check git is installed (git --version)" | tee -a "$LOGFILE"
    echo "Check tmux is installed (tmux -V)" | tee -a "$LOGFILE"
    echo "Check aws cli is installed (aws --version)" | tee -a "$LOGFILE"
    echo "Check aws sam is installed (sam --version)" | tee -a "$LOGFILE"
    echo "Check node is installed (node --version)" | tee -a "$LOGFILE"
    echo "Check npm is installed (npm --version)" | tee -a "$LOGFILE"
    echo "Check aws cdk is installed (cdk --version)" | tee -a "$LOGFILE"
    echo "Check Tree is installed (tree --version)" | tee -a "$LOGFILE"
    echo "Check pyenv is installed (pyenv --version)" | tee -a "$LOGFILE"
    echo "Check Docker is installed (docker --version)" | tee -a "$LOGFILE"
    echo "Check Luarocks is installed (luarocks --version)" | tee -a "$LOGFILE"
    echo "Check Neovim has proper plugins setup (open nvim, run :Lazy to verify plugins)" | tee -a "$LOGFILE"
    echo "Check Mason is set up in Neovim (:Mason to verify LSP servers are installed)" | tee -a "$LOGFILE"
    echo "Check that sudoedit uses Neovim" | tee -a "$LOGFILE"
    echo "Check that flameshot has been installed and you can take screenshots" | tee -a "$LOGFILE"
    echo "Check Terraform has been installed (terraform --version)" | tee -a "$LOGFILE"
    echo "Note: configure the Terraform version with tfenv — run 'tfenv install'" | tee -a "$LOGFILE"
    echo "Check that Remmina has been installed (remmina --version)" | tee -a "$LOGFILE"
    echo "Check VS Code is installed (code --version) and the Neovim extension is active" | tee -a "$LOGFILE"
    echo "NOTE: If you added docker group membership, log out and back in for it to take effect" | tee -a "$LOGFILE"
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
lsp_install
set_sudo_default_editor
terraform_install
remmina_install
vscode_install
plantuml_install
home_folder_permissions
final_checklist
#bootstrap_crontab

END_TIME=$(date +"%d-%m-%Y_%H_%M_%S")
echo "Ending eitas dotfile install on $END_TIME" | tee -a "$LOGFILE"
exit 0
