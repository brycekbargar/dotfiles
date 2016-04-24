#!/bin/zsh
#
# bryces-dotfiles-zshrc
#

autoload -U promptinit compinit

promptinit
prompt bart

compinit -d "$HOME/.zsh_zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

setopt NULL_GLOB
for thisZshFile in "$HOME/.zshrcfiles/."*; do
  source "$thisZshFile" > /dev/null
done
setopt NO_NULL_GLOB

export EDITOR='nvim'
export VISUAL='nvim'
