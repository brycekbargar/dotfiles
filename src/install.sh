#!/bin/bash

source "$(pwd)/utils/logging"

log_step "01 Set Environment"
source "$(pwd)/utils/set-environment"

log_step "02 Setup Package Manager"
source "$(pwd)/$ENVIRONMENT/02_setup-package-manager"

log_step "03 Sync SSH Keys"
source "$(pwd)/$ENVIRONMENT/03_sync-ssh-keys"

log_step "04 Install git"
source "$(pwd)/$ENVIRONMENT/04_install-git"

log_step "05 Install zsh"
source "$(pwd)/$ENVIRONMENT/05_install-zsh"

log_step "06 Install tmux"
source "$(pwd)/$ENVIRONMENT/06_install-tmux"

log_step "07 Install neovim"
source "$(pwd)/$ENVIRONMENT/07_install-neovim"

log_step "08 Install Environment Specific Packages"
source "$(pwd)/$ENVIRONMENT/08_packages"

exit 0
