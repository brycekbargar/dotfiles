#!/bin/bash

# Set the path to the src folder depending on where the script is run fromj
srcDir="$(dirname $0)"

source "$srcDir/utils/logging"

log_step "01 Set Environment"
source "$srcDir/utils/set-environment"

log_step "02 Setup Package Manager"
source "$srcDir/$ENVIRONMENT/02_setup-package-manager"

log_step "03 Sync SSH Keys"
source "$srcDir/$ENVIRONMENT/03_sync-ssh-keys"

log_step "04 Install git"
source "$srcDir/$ENVIRONMENT/04_install-git"

log_step "05 Install zsh"
source "$srcDir/$ENVIRONMENT/05_install-zsh"

log_step "06 Install tmux"
source "$srcDir/$ENVIRONMENT/06_install-tmux"

log_step "07 Install neovim"
source "$srcDir/$ENVIRONMENT/07_install-neovim"

log_step "08 Install Environment Specific Packages"
source "$srcDir/$ENVIRONMENT/08_packages"

exit 0
