#!/bin/zsh
#
# bryces-dotfiles-zshrc
#

export PREFIX=/usr/local

for thisPath in \
  "$PREFIX/bin" \
  "$PREFIX/sbin"; do
  
  case ":$PATH:" in
    *":$thisPath:"*) :;; # already there
    *) PATH="$PATH:$thisPath";;
  esac
done

setopt NULL_GLOB
for thisZshFile in "$HOME/.zshrcfiles/."*; do
  source "$thisZshFile" > /dev/null
done
setopt NO_NULL_GLOB
