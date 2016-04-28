#!/bin/bash
#
# Run to setup dotfiles
#
source init

requires ssh-host-key
requires ssh-identity-keys

requires lastpass-installed
requires zsh-installed

requires packages

requires symlinked-zshrc
requires symlinked-nvim
requires symlinked-gitconfig

requires symlinked-pqrs

requires elm-installed

exit 0
