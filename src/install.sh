#!/bin/bash

# Set the path to the src folder depending on where the script is run fromj
srcDir="$(dirname $0)"

source "$srcDir/utils/logging"

log_step "01 Set Environment"
source "$srcDir/utils/set-environment"

log_step "02 Setup Package Manager"
source "$srcDir/$ENVIRONMENT/02-setup-package-manager"

log_step "03 Sync SSH Keys"
source "$srcDir/$ENVIRONMENT/03-sync-ssh-keys"

log_step "04 Install git"
source "$srcDir/$ENVIRONMENT/04-install-git"

log_step "05 Install zsh"
source "$srcDir/$ENVIRONMENT/05-install-zsh"

log_step "06 Install tmux"
source "$srcDir/$ENVIRONMENT/06-install-tmux"

log_step "07 Install neovim"
source "$srcDir/$ENVIRONMENT/07-install-neovim"

log_step "08 Install Environment Specific Packages"
source "$srcDir/$ENVIRONMENT/08-packages"

exit 0
