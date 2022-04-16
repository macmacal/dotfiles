#!/bin/bash

# ZSH plugin manager Antibody
curl -sfL git.io/antibody | sh -s - -b $HOME/.local/bin

# Neovim-plug plugin manager
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
