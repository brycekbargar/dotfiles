#!/usr/bin/env bash

brew install karabiner-elements
brew install orbstack
brew install less

# kitty
ln -sf "$HOME/_setup/dotfiles/host/kitty.conf" "$HOME/.config/kitty/kitty.conf"
kitty +kitten themes Catppuccin-Macchiato

# vim
brew install vim
brew install ripgrep
mkdir -p ~/.vim/pack/common
pushd ~/.vim/pack/common || exit
git clone --depth 1 --single-branch -- "https://github.com/lifepillar/vim-mucomplete" "start/mucomplete"
git clone --depth 1 --single-branch -- "https://github.com/tpope/vim-sensible" "start/sensible"
git clone --depth 1 --single-branch -- "https://github.com/tpope/vim-sleuth" "start/sleuth"
git clone --depth 1 --single-branch -- "https://github.com/tpope/vim-vinegar" "start/vinegar"
git clone --depth 1 --single-branch -- "https://github.com/catppuccin/vim" "opt/catppuccin-vim"
popd || exit
ln -sf "$HOME/_setup/dotfiles/XDG_CONFIG_HOME/nvim/init.vim" "$HOME/.vimrc"

# zsh
ln -sf "$HOME/_setup/dotfiles/host/.zshenv" "$HOME/.zshenv"

# random stuff
mkdir -p ~/_setup/private
