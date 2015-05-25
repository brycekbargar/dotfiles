#!/bin/zsh
#
# bryces-dotfiles-zshrc
#

autoload -U promptinit

promptinit
prompt bart

setopt NULL_GLOB
for thisZshFile in "$HOME/.zshrcfiles/."*; do
  source "$thisZshFile" > /dev/null
done
setopt NO_NULL_GLOB
