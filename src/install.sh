#!/bin/bash

# Set the path to the src folder depending on where the script is run fromj
SRC="$(dirname $0)"
DOTFILES="$(dirname $0)/../dotfiles/"

source "$SRC/utils/logging"

log_step "01 Set Environment"
source "$SRC/utils/set-environment"

log_step "02 Setup Package Manager"
source "$SRC/$ENVIRONMENT/02-setup-package-manager"

log_step "03 Sync SSH Keys"
source "$SRC/$ENVIRONMENT/03-sync-ssh-keys"

log_step "04 Install git"
source "$SRC/$ENVIRONMENT/04-install-git"

log_step "05 Install zsh"
source "$SRC/$ENVIRONMENT/05-install-zsh"

log_step "06 Install tmux"
source "$SRC/$ENVIRONMENT/06-install-tmux"

log_step "07 Install neovim"
source "$SRC/$ENVIRONMENT/07-install-neovim"

log_step "08 Install Environment Specific Packages"
source "$SRC/$ENVIRONMENT/08-packages"

exit 0
