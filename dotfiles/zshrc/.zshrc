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