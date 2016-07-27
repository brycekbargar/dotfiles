#!/bin/zsh

source "$HOME/.zshrcfiles/antigen.zsh"
source "$HOME/.zshrcfiles/local.zsh"

antigen bundle brycekbargar/dotfiles dotfiles/zsh/shared
antigen apply
