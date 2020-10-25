#!/bin/bash

# Jump to and resolve the full path to relevant folders
pushd "$(dirname $0)"
  SRC="$(pwd)"
  pushd '../'
    DOTFILES="$(pwd)/dotfiles/"
  popd
popd

# TODO: Replace this with something less hand-rolled
source "$SRC/utils/logging"

source "$SRC/setup-package-manager"
source "$SRC/install-zsh"

log_step "02 Install Dotfiles Packages"
source "$SRC/$ENVIRONMENT/02-install-dotfiles-packages"

log_step "03 Sync SSH Keys"
source "$SRC/$ENVIRONMENT/03-sync-ssh-keys"

source "$SRC/$ENVIRONMENT/04-install-zsh"

log_step "05 Install git"
source "$SRC/$ENVIRONMENT/05-install-git"

log_step "06 Install tmux"
source "$SRC/$ENVIRONMENT/06-install-tmux"

log_step "07 Install neovim"
source "$SRC/$ENVIRONMENT/07-install-neovim"

log_step "08 Install Environment Specific Packages"
source "$SRC/$ENVIRONMENT/08-packages"

exit 0
