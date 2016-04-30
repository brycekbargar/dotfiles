#!/bin/zsh
#
# bryces-dotfiles-zshrc
#

source "$HOME/.zshrcfiles/local.zsh"
source "$HOME/.zshrcfiles/antigen.zsh"

antigen bundle brycekbargar/dotfiles dotfiles/zsh/plugin
antigen apply
