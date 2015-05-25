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

if [ -d "$HOME/.zshrcfiles" ] && [ $(ls -A "$HOME/.zshrcfiles") ]; then
  for thisZshFile in "$HOME/.zshrcfiles/."*; do
    source "$thisZshFile" > /dev/null
  done
fi
