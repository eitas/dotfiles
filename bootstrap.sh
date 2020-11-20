#!/bin/bash

# inspiration from https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/
# Bootstrap for install on new machines and maintaining structure on existing machines
#
#
# firstly setup any required environment variables
source .exports

init() {
    echo "Making github forder in $PATH_TO_DOTFILES if it does not already exist"
    mkdir -p "$PATH_TO_DOTFILES"
}

link() {
    for file in $PATH_TO_DOTFILES/.{extra,bash_prompt,exports,aliases,functions}; do
      # silently ignore errors as the files may already exist
      ln -sv "$PWD/$file" "$HOME" || true
    done
    unset file
}

install_tools() {



