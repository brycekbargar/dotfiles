#!/usr/bin/env bash

brew install karabiner-elements
brew install orbstack
brew install less
brew install vim

ln -sf "$HOME/_setup/dotfiles/host/.zshenv" "$HOME/.zshenv"
